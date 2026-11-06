#!/usr/bin/env python3
"""
typst_to_md.py - converts the Typst notebook (notebook.typ + lib.typ model)
into a single GitHub-flavoured Markdown file (README.md).

What it understands
  * notebook.typ: `#show: project.with(...)` (title/author/year) and every
    `#subject("Name (CODE)", ..., include "file.typ", [ #heading(...) ... ])`
  * Typst markup: headings, lists (- / +), *bold*, _italic_, `code`,
    ```code blocks```, \\ line breaks, comments, escapes, #link, #sym...
  * lib.typ environments:  Highlight1 -> [!NOTE], Highlight2 -> [!IMPORTANT],
    example -> [!TIP]  (GitHub alert boxes)
  * #figure / #image (centered <img>), #table (Markdown table), #grid, #align
  * CeTZ drawings (`canvas(...)`): compiled to SVG with the `typst` CLI and
    embedded as images (assets/readme/*.svg)
  * Math: Typst math -> LaTeX (fractions, scripts, mat, cases, underbrace,
    root, binom, cal, dv/dvp from diverential, symbols ...). Inline math is
    written as $`...`$ and display math as ```math blocks (GitHub syntax).

Usage
  python3 typst_to_md.py                 # notebook.typ -> README.md
  python3 typst_to_md.py -i notebook.typ -o README.md --no-figures
"""

from __future__ import annotations

import argparse
import hashlib
import os
import re
import shutil
import subprocess
import sys
import tempfile
import textwrap
from dataclasses import dataclass, field
from pathlib import Path

# ════════════════════════════════════════════════════════════════════════
#  Generic scanning helpers (balanced brackets, strings, math, raw)
# ════════════════════════════════════════════════════════════════════════

IDENT_RE = re.compile(r"[A-Za-z_][A-Za-z0-9_-]*(?:\.[A-Za-z_][A-Za-z0-9_-]*)*")


def skip_string(s: str, i: int) -> int:
    """s[i] == '"' -> index after the closing quote."""
    i += 1
    while i < len(s):
        if s[i] == "\\":
            i += 2
            continue
        if s[i] == '"':
            return i + 1
        i += 1
    return i


def skip_raw(s: str, i: int) -> int:
    """s[i] == '`' -> index after the matching backtick(s)."""
    if s.startswith("```", i):
        j = s.find("```", i + 3)
        return len(s) if j < 0 else j + 3
    j = s.find("`", i + 1)
    return len(s) if j < 0 else j + 1


def skip_math(s: str, i: int) -> int:
    """s[i] == '$' -> index after the closing '$'."""
    i += 1
    while i < len(s):
        c = s[i]
        if c == "\\":
            i += 2
            continue
        if c == '"':
            i = skip_string(s, i)
            continue
        if c == "$":
            return i + 1
        i += 1
    return i


def skip_content(s: str, i: int) -> int:
    """s[i] == '[' (content block) -> index after the matching ']'."""
    i += 1
    while i < len(s):
        c = s[i]
        if c == "\\":
            i += 2
            continue
        if c == "[":
            i = skip_content(s, i)
            continue
        if c == "]":
            return i + 1
        if c == "$":
            i = skip_math(s, i)
            continue
        if c == "`":
            i = skip_raw(s, i)
            continue
        if c == "/" and s.startswith("//", i) and (i == 0 or s[i - 1] in " \t\n"):
            j = s.find("\n", i)
            i = len(s) if j < 0 else j
            continue
        if c == "#":
            m = IDENT_RE.match(s, i + 1)
            if m:
                i = m.end()
                if i < len(s) and s[i] == "(":
                    i = skip_code(s, i)
                continue
        i += 1
    return i


def skip_code(s: str, i: int) -> int:
    """s[i] in '({' (code) -> index after the matching closer."""
    close = {"(": ")", "{": "}"}[s[i]]
    i += 1
    while i < len(s):
        c = s[i]
        if c == close:
            return i + 1
        if c in "({":
            i = skip_code(s, i)
        elif c == "[":
            i = skip_content(s, i)
        elif c == '"':
            i = skip_string(s, i)
        elif c == "$":
            i = skip_math(s, i)
        elif c == "/" and s.startswith("//", i):
            j = s.find("\n", i)
            i = len(s) if j < 0 else j
        elif c == "/" and s.startswith("/*", i):
            j = s.find("*/", i)
            i = len(s) if j < 0 else j + 2
        else:
            i += 1
    return i


def split_top(s: str, seps: str = ",") -> list[str]:
    """Split code text at top-level separators (outside brackets/strings)."""
    parts, depth_start, i = [], 0, 0
    while i < len(s):
        c = s[i]
        if c in "({":
            i = skip_code(s, i)
            continue
        if c == "[":
            i = skip_content(s, i)
            continue
        if c == '"':
            i = skip_string(s, i)
            continue
        if c == "$":
            i = skip_math(s, i)
            continue
        if c in seps:
            parts.append(s[depth_start:i])
            depth_start = i + 1
        i += 1
    parts.append(s[depth_start:])
    return [p.strip() for p in parts if p.strip()]


@dataclass
class Call:
    name: str
    pos: list[str] = field(default_factory=list)      # positional args (raw code)
    named: dict[str, str] = field(default_factory=dict)
    bodies: list[str] = field(default_factory=list)   # trailing [content] blocks
    end: int = 0


def parse_call(s: str, i: int) -> Call | None:
    """Parse `ident(.ident)*` + optional (args) + [bodies] starting at s[i]."""
    m = IDENT_RE.match(s, i)
    if not m:
        return None
    call = Call(m.group(0))
    i = m.end()
    if i < len(s) and s[i] == "(":
        j = skip_code(s, i)
        for arg in split_top(s[i + 1 : j - 1]):
            nm = re.match(r"^([A-Za-z_][A-Za-z0-9_-]*)\s*:(?!=)\s*(.*)$", arg, re.S)
            if nm and not arg.startswith('"'):
                call.named[nm.group(1)] = nm.group(2).strip()
            else:
                call.pos.append(arg)
        i = j
    while i < len(s) and s[i] == "[":
        j = skip_content(s, i)
        call.bodies.append(s[i + 1 : j - 1])
        i = j
    call.end = i
    return call


def unquote(v: str) -> str:
    v = v.strip()
    if len(v) >= 2 and v[0] == '"' and v[-1] == '"':
        return bytes(v[1:-1], "utf-8").decode("unicode_escape").encode("latin-1").decode("utf-8") if "\\" in v else v[1:-1]
    return v


# ════════════════════════════════════════════════════════════════════════
#  Typst math  ->  LaTeX
# ════════════════════════════════════════════════════════════════════════

GREEK = (
    "alpha beta gamma delta epsilon zeta eta theta iota kappa lambda mu nu xi "
    "omicron pi rho sigma tau upsilon phi chi psi omega Gamma Delta Theta Lambda "
    "Xi Pi Sigma Upsilon Phi Psi Omega"
).split()

SYMBOLS = {g: "\\" + g for g in GREEK}
SYMBOLS.update({
    "epsilon": r"\varepsilon", "epsilon.alt": r"\epsilon", "phi.alt": r"\varphi",
    "theta.alt": r"\vartheta", "omicron": "o",
    # spacing
    "quad": r"\quad", "qquad": r"\qquad", "wide": r"\qquad", "space": r"\ ",
    "thin": r"\,", "med": r"\:", "thick": r"\;",
    # sets / logic
    "RR": r"\mathbb{R}", "NN": r"\mathbb{N}", "ZZ": r"\mathbb{Z}", "QQ": r"\mathbb{Q}",
    "CC": r"\mathbb{C}", "in": r"\in", "in.not": r"\notin", "subset": r"\subset",
    "subset.eq": r"\subseteq", "supset": r"\supset", "union": r"\cup", "inter": r"\cap",
    "union.big": r"\bigcup", "inter.big": r"\bigcap", "emptyset": r"\emptyset",
    "nothing": r"\varnothing", "forall": r"\forall", "exists": r"\exists",
    "exists.not": r"\nexists", "not": r"\neg", "and": r"\wedge", "or": r"\lor",
    "therefore": r"\therefore", "because": r"\because", "top": r"\top", "bot": r"\bot",
    # relations
    "eq": "=", "eq.not": r"\neq", "lt": "<", "gt": ">", "lt.eq": r"\le", "gt.eq": r"\ge",
    "lt.eq.not": r"\not\le", "gt.eq.not": r"\not\ge", "approx": r"\approx",
    "equiv": r"\equiv", "prop": r"\propto", "tilde.op": r"\sim", "sim": r"\sim",
    "divides": r"\mid", "parallel": r"\parallel", "perp": r"\perp",
    # operators
    "plus": "+", "minus": "-", "plus.minus": r"\pm", "minus.plus": r"\mp",
    "times": r"\times", "div": r"\div", "dot": r"\cdot", "dot.op": r"\cdot",
    "ast": r"\ast", "star": r"\star", "circle.small": r"\circ", "compose": r"\circ",
    "mod": r"\bmod", "integral": r"\int", "integral.double": r"\iint",
    "integral.cont": r"\oint", "sum": r"\sum", "product": r"\prod",
    "partial": r"\partial", "nabla": r"\nabla", "infinity": r"\infty", "oo": r"\infty",
    "dif": r"\mathrm{d}", "Dif": r"\mathrm{D}", "degree": r"^\circ", "prime": "'",
    # dots
    "dots": r"\ldots", "dots.h": r"\ldots", "dots.c": r"\cdots", "dots.v": r"\vdots",
    "dots.down": r"\ddots", "dots.up": r"\iddots",
    # arrows
    "arrow.r": r"\rightarrow", "arrow.l": r"\leftarrow", "arrow.t": r"\uparrow",
    "arrow.b": r"\downarrow", "arrow.l.r": r"\leftrightarrow",
    "arrow.r.double": r"\Rightarrow", "arrow.l.double": r"\Leftarrow",
    "arrow.l.r.double": r"\Leftrightarrow", "arrow.r.l.double": r"\Leftrightarrow",
    "arrow.r.long": r"\longrightarrow", "arrow.r.double.long": r"\Longrightarrow",
    "arrow.r.bar": r"\mapsto", "arrow.r.squiggly": r"\rightsquigarrow",
    "arrows.rl": r"\rightleftarrows",
    # misc
    "angle.l": r"\langle", "angle.r": r"\rangle", "chevron.l": r"\langle", "chevron.r": r"\rangle",
    "integral.triple": r"\iiint", "without": r"\setminus", "emptyset": r"\emptyset", "bar.v": "|", "bar.v.double": r"\|",
    "checkmark": r"\checkmark", "square": r"\square", "triangle": r"\triangle",
    "hat": r"\hat{}", "colon": ":", "comma": ",", "excl": "!", "hash": r"\#",
    "percent": r"\%", "ell": r"\ell", "planck.reduce": r"\hbar", "aleph": r"\aleph",
})

OPNAMES = set(
    "sin cos tan cot sec csc sinh cosh tanh arcsin arccos arctan log ln lg exp "
    "lim limsup liminf max min sup inf det gcd lcm deg dim ker arg Pr".split()
)

MULTI_OPS = [
    ("<==>", r"\Longleftrightarrow"), ("==>", r"\Longrightarrow"), ("<=>", r"\Leftrightarrow"),
    ("|->", r"\mapsto"), ("<->", r"\leftrightarrow"), ("...", r"\ldots"),
    ("=>", r"\Rightarrow"), ("<=", r"\le"), (">=", r"\ge"), ("!=", r"\neq"),
    ("->", r"\to"), ("<-", r"\leftarrow"), (":=", r"\coloneqq"), ("<<", r"\ll"),
    (">>", r"\gg"), ("||", r"\|"),
]

ARROWISH = re.compile(r"\\(right|left|Right|Left|leftright|Leftright|long|Long|mapsto|to\b)")


def tex_text(t: str) -> str:
    t = t.replace("\\", r"\backslash ")
    for ch in "#%&_{}$":
        t = t.replace(ch, "\\" + ch)
    return r"\text{" + t + "}"


class MathParser:
    def __init__(self, src: str):
        self.toks = self.tokenize(src)
        self.p = 0
        self.has_align = False
        self.has_break = False

    # ── tokenizer ─────────────────────────────────────────────────────
    @staticmethod
    def tokenize(s: str):
        toks, i, n = [], 0, len(s)
        while i < n:
            c = s[i]
            if c in " \t\n\r":
                j = i
                while j < n and s[j] in " \t\n\r":
                    j += 1
                toks.append(("ws", " "))
                i = j
                continue
            if c == '"':
                j = skip_string(s, i)
                toks.append(("str", s[i + 1 : j - 1].replace('\\"', '"')))
                i = j
                continue
            if c == "\\":
                if i + 1 >= n or s[i + 1] in " \t\n\r":
                    toks.append(("break", None))
                    i += 1
                else:
                    toks.append(("esc", s[i + 1]))
                    i += 2
                continue
            if c == "#":
                m = IDENT_RE.match(s, i + 1)
                if m:
                    name = m.group(0)
                    j = m.end()
                    if j < n and s[j] == "(":
                        j = skip_code(s, j)
                    toks.append(("code", name))
                    i = j
                    continue
            if c.isdigit():
                m = re.match(r"\d+(?:\.\d+)?", s[i:])
                toks.append(("num", m.group(0)))
                i += m.end()
                continue
            if c.isalpha():
                m = re.match(r"[^\W\d_]+[0-9]*", s[i:])
                word = m.group(0)
                j = i + m.end()
                if len(word) > 1:  # field access only on multi-letter idents
                    while j < n and s[j] == "." and j + 1 < n and s[j + 1].isalpha():
                        m2 = re.match(r"\.[A-Za-z]+", s[j:])
                        word += m2.group(0)
                        j += m2.end()
                toks.append(("id", word))
                i = j
                continue
            for op, tex in MULTI_OPS:
                if s.startswith(op, i):
                    toks.append(("sym", tex))
                    i += len(op)
                    break
            else:
                toks.append(("p" if c in "()[]{},;_^&/'" else "op", c))
                i += 1
        return toks

    # ── helpers ───────────────────────────────────────────────────────
    def peek(self, k=0):
        j = self.p + k
        return self.toks[j] if j < len(self.toks) else (None, None)

    def skip_ws(self):
        while self.peek()[0] == "ws":
            self.p += 1

    # ── grammar ───────────────────────────────────────────────────────
    def parse_seq(self, stops=()):
        items = []  # each: ("unit", latex, inner|None) | ("ws",) | ("frac",)
        while True:
            t, v = self.peek()
            if t is None:
                break
            if t == "p" and v in stops:
                break
            if t == "ws":
                self.p += 1
                items.append(("ws",))
            elif t == "break":
                self.p += 1
                self.has_break = True
                items.append(("unit", r"\\", None))
            elif t == "p" and v == "&":
                self.p += 1
                self.has_align = True
                items.append(("unit", "&", None))
            elif t == "p" and v == "/":
                self.p += 1
                items.append(("frac",))
            elif t == "p" and v in ",;)]}":
                self.p += 1
                items.append(("unit", {"]": "]", "}": r"\}"}.get(v, v), None))
            else:
                items.append(self.parse_unit())
        return self.fold(items)

    def fold(self, items) -> str:
        out = []  # list of units ("unit", latex, inner)
        k = 0
        while k < len(items):
            it = items[k]
            if it[0] == "frac":
                while out and out[-1][0] == "ws":
                    out.pop()
                num = out.pop() if out else ("unit", "", None)
                k += 1
                while k < len(items) and items[k][0] == "ws":
                    k += 1
                den = items[k] if k < len(items) else ("unit", "", None)
                if den[0] != "unit":
                    den = ("unit", "", None)
                out.append(("unit", r"\frac{%s}{%s}" % (self.bare(num), self.bare(den)), None))
            else:
                out.append(it)
            k += 1
        res = []
        for it in out:
            if it[0] == "unit":
                res.append(it[1])
        return " ".join(x for x in res if x != "")

    @staticmethod
    def bare(unit) -> str:
        """Operand of a fraction / script: drop the outer parentheses."""
        return unit[2] if unit[2] is not None else unit[1]

    def parse_unit(self):
        base = self.parse_primary()
        sub = sup = None
        primes = ""
        while True:
            t, v = self.peek()
            if t == "p" and v == "'":
                self.p += 1
                primes += "'"
            elif t == "p" and v in "_^":
                self.p += 1
                arg = self.parse_primary()
                if v == "_":
                    sub = self.bare(arg)
                else:
                    sup = self.bare(arg)
            else:
                break
        tex = base[1] + primes
        if sup is not None and sub is None and not primes and ARROWISH.match(base[1]):
            return ("unit", r"\overset{%s}{%s}" % (sup, base[1]), None)
        if sub is not None or sup is not None:
            if base[2] is None and " " in tex.strip() and not tex.startswith("\\"):
                tex = "{" + tex + "}"
            if sub is not None:
                tex += "_{" + sub + "}"
            if sup is not None:
                tex += "^{" + sup + "}"
            return ("unit", tex, None)
        return ("unit", tex, base[2] if not primes else None)

    def group(self, open_, close, left, right):
        inner = self.parse_seq(stops=(close,))
        if self.peek() == ("p", close):
            self.p += 1
        big = any(k in inner for k in (r"\frac", r"\begin", r"\sum", r"\int", r"\underbrace", r"\prod"))
        if big:
            return ("unit", r"\left%s %s \right%s" % (left, inner, right), inner)
        return ("unit", "%s%s%s" % (left, inner, right), inner)

    def parse_primary(self):
        self.skip_ws() if self.peek()[0] == "ws" and False else None
        t, v = self.peek()
        if t is None:
            return ("unit", "", None)
        self.p += 1
        if t == "num":
            return ("unit", v, None)
        if t == "str":
            return ("unit", tex_text(v), None)
        if t == "sym":
            return ("unit", v, None)
        if t == "esc":
            return ("unit", {"{": r"\{", "}": r"\}", "#": r"\#", "%": r"\%", "&": r"\&",
                             "$": r"\$", "_": r"\_", "\\": r"\backslash"}.get(v, v), None)
        if t == "code":
            name = v.removeprefix("sym.")
            if name in SYMBOLS:
                return ("unit", SYMBOLS[name], None)
            return ("unit", r"\ ", None)
        if t == "p":
            if v == "(":
                return self.group("(", ")", "(", ")")
            if v == "[":
                return self.group("[", "]", "[", "]")
            if v == "{":
                return self.group("{", "}", r"\{", r"\}")
            return ("unit", v, None)
        if t == "op":
            return ("unit", {"*": r"\ast", "%": r"\%", "~": r"\sim", "#": r"\#"}.get(v, v), None)
        if t == "id":
            return self.ident(v)
        return ("unit", str(v), None)

    # ── identifiers & functions ───────────────────────────────────────
    def args(self):
        """After '(' : parse args until ')'. Returns (rows, named)."""
        rows, row, named = [], [], {}
        while True:
            self.skip_ws()
            t, v = self.peek()
            if t is None:
                break
            if t == "p" and v == ")":
                self.p += 1
                break
            # named argument  ident: value
            if t == "id" and self.peek(1) == ("op", ":"):
                key = v
                self.p += 2
                self.skip_ws()
                tv = self.peek()
                if tv[0] == "str":
                    self.p += 1
                    named[key] = tv[1]
                else:
                    named[key] = self.parse_seq(stops=(",", ";", ")"))
                if self.peek() == ("p", ","):
                    self.p += 1
                continue
            val = self.parse_seq(stops=(",", ";", ")")).strip()
            row.append(val)
            t, v = self.peek()
            if t == "p" and v == ",":
                self.p += 1
            elif t == "p" and v == ";":
                self.p += 1
                rows.append(row)
                row = []
        if row or not rows:
            rows.append(row)
        return rows, named

    def ident(self, name):
        immediate_call = self.peek() == ("p", "(")
        if immediate_call and name in FUNCS:
            self.p += 1
            rows, named = self.args()
            flat = [a for r in rows for a in r]
            return ("unit", FUNCS[name](flat, rows, named), None)
        if name in OPNAMES:
            return ("unit", "\\" + name, None)
        if len(name) == 1 and "." not in name:
            return ("unit", name, None)
        if name in SYMBOLS:
            return ("unit", SYMBOLS[name], None)
        if immediate_call:
            return ("unit", r"\operatorname{%s}" % name, None)
        return ("unit", r"\mathrm{%s}" % name, None)


def _a(args, k, default=""):
    return args[k] if k < len(args) else default


def _matrix(env_default):
    def f(flat, rows, named):
        delim = named.get("delim", None)
        env = {"|": "vmatrix", "||": "Vmatrix", "[": "bmatrix", "{": "Bmatrix",
               "(": "pmatrix", "none": "matrix", "#none": "matrix"}.get(delim, env_default)
        body = r" \\ ".join(" & ".join(r) for r in rows)
        return r"\begin{%s} %s \end{%s}" % (env, body, env)
    return f


def _vec(flat, rows, named):
    return r"\begin{pmatrix} %s \end{pmatrix}" % r" \\ ".join(flat)


def _cases(flat, rows, named):
    return r"\begin{cases} %s \end{cases}" % r" \\ ".join(flat)


def _dv(partial):
    d = r"\partial" if partial else r"\mathrm{d}"

    def f(flat, rows, named):
        fn, vars_ = _a(flat, 0), flat[1:]
        if not vars_:
            vars_ = ["x"]
        if len(vars_) == 2 and re.fullmatch(r"\d+", vars_[1]) and not partial:
            n = vars_[1]
            return r"\frac{%s^{%s} %s}{%s %s^{%s}}" % (d, n, fn, d, vars_[0], n)
        order = len(vars_)
        num = d + (("^{%d}" % order) if order > 1 else "") + " " + fn
        den = " ".join(d + " " + v for v in vars_)
        return r"\frac{%s}{%s}" % (num, den)
    return f


FUNCS = {
    "frac": lambda a, r, n: r"\frac{%s}{%s}" % (_a(a, 0), _a(a, 1)),
    "sqrt": lambda a, r, n: r"\sqrt{%s}" % _a(a, 0),
    "root": lambda a, r, n: r"\sqrt[%s]{%s}" % (_a(a, 0), _a(a, 1)),
    "binom": lambda a, r, n: r"\binom{%s}{%s}" % (_a(a, 0), _a(a, 1)),
    "abs": lambda a, r, n: r"\left\lvert %s \right\rvert" % _a(a, 0),
    "norm": lambda a, r, n: r"\left\lVert %s \right\rVert" % _a(a, 0),
    "floor": lambda a, r, n: r"\lfloor %s \rfloor" % _a(a, 0),
    "ceil": lambda a, r, n: r"\lceil %s \rceil" % _a(a, 0),
    "round": lambda a, r, n: r"\lfloor %s \rceil" % _a(a, 0),
    "cal": lambda a, r, n: r"\mathcal{%s}" % _a(a, 0),
    "bb": lambda a, r, n: r"\mathbb{%s}" % _a(a, 0),
    "frak": lambda a, r, n: r"\mathfrak{%s}" % _a(a, 0),
    "bold": lambda a, r, n: r"\boldsymbol{%s}" % _a(a, 0),
    "upright": lambda a, r, n: r"\mathrm{%s}" % _a(a, 0),
    "italic": lambda a, r, n: r"\mathit{%s}" % _a(a, 0),
    "sans": lambda a, r, n: r"\mathsf{%s}" % _a(a, 0),
    "mono": lambda a, r, n: r"\mathtt{%s}" % _a(a, 0),
    "op": lambda a, r, n: r"\operatorname{%s}" % re.sub(r"^\\text\{(.*)\}$", r"\1", _a(a, 0)),
    "display": lambda a, r, n: r"{\displaystyle %s}" % _a(a, 0),
    "inline": lambda a, r, n: r"{\textstyle %s}" % _a(a, 0),
    "overline": lambda a, r, n: r"\overline{%s}" % _a(a, 0),
    "underline": lambda a, r, n: r"\underline{%s}" % _a(a, 0),
    "bar": lambda a, r, n: r"\bar{%s}" % _a(a, 0),
    "hat": lambda a, r, n: r"\hat{%s}" % _a(a, 0),
    "tilde": lambda a, r, n: r"\tilde{%s}" % _a(a, 0),
    "dot": lambda a, r, n: r"\dot{%s}" % _a(a, 0),
    "dot.double": lambda a, r, n: r"\ddot{%s}" % _a(a, 0),
    "arrow": lambda a, r, n: r"\vec{%s}" % _a(a, 0),
    "cancel": lambda a, r, n: r"\cancel{%s}" % _a(a, 0),
    "underbrace": lambda a, r, n: r"\underbrace{%s}_{%s}" % (_a(a, 0), _a(a, 1)),
    "overbrace": lambda a, r, n: r"\overbrace{%s}^{%s}" % (_a(a, 0), _a(a, 1)),
    "underbracket": lambda a, r, n: r"\underbrace{%s}_{%s}" % (_a(a, 0), _a(a, 1)),
    "lr": lambda a, r, n: _a(a, 0),
    "limits": lambda a, r, n: _a(a, 0) + r"\limits",
    "mat": _matrix("pmatrix"),
    "vec": _vec,
    "cases": _cases,
    "dv": _dv(False),
    "dvp": _dv(True),
}


def math_to_latex(src: str) -> tuple[str, bool]:
    """Returns (latex, multiline)."""
    mp = MathParser(src.strip())
    tex = mp.parse_seq()
    tex = re.sub(r"\s+", " ", tex).strip()
    multiline = mp.has_break or mp.has_align
    if multiline:
        env = "aligned" if mp.has_align else "gathered"
        tex = r"\begin{%s} %s \end{%s}" % (env, tex, env)
    return tex, multiline


# ════════════════════════════════════════════════════════════════════════
#  Typst markup  ->  Markdown
# ════════════════════════════════════════════════════════════════════════

SYM_TEXT = {"checkmark": "✓", "crossmark": "✗", "arrow.r": "→", "arrow.l": "←",
            "arrow.r.double": "⇒", "star": "★", "bullet": "•", "dots": "…",
            "copyright": "©", "degree": "°", "times": "×"}

ALERTS = {"Highlight1": "NOTE", "Highlight2": "IMPORTANT", "example": "TIP"}


class Converter:
    def __init__(self, root: Path, figures: bool = True):
        self.root = root                       # Notebook/ (README location)
        self.figures = figures
        self.fig_dir = root / "assets" / "readme"
        self.fig_count = 0
        self.heading_counter = [0] * 8         # notebook heading levels 1..7
        self.toc: list[tuple[int, str, str]] = []
        self.slugs: dict[str, int] = {}
        self.cur_file: Path | None = None
        self.file_preamble = ""                # #import/#let lines for canvases
        self.default_lang = ""                 # subject's default code language

    # ── headings ──────────────────────────────────────────────────────
    def heading(self, level: int, text_md: str) -> str:
        level = max(1, level)
        self.heading_counter[level] += 1
        for k in range(level + 1, len(self.heading_counter)):
            self.heading_counter[k] = 0
        number = ""
        if 2 <= level <= 3:  # same rule as lib.typ
            number = ".".join(str(self.heading_counter[k]) for k in range(2, level + 1)) + ". "
        title = number + text_md.strip()
        self.toc.append((level, title, self.slug(title)))
        return "\n" + "#" * min(level, 6) + " " + title + "\n\n"

    def slug(self, title: str) -> str:
        s = re.sub(r"\$`([^`]*)`\$", lambda m: re.sub(r"\\[A-Za-z]+", "", m.group(1)), title).lower()
        s = re.sub(r"[^\w\- ]", "", s).replace(" ", "-")
        n = self.slugs.get(s, 0)
        self.slugs[s] = n + 1
        return s if n == 0 else f"{s}-{n}"

    # ── markup ────────────────────────────────────────────────────────
    def markup(self, src: str, offset: int = 0, depth: int = 0) -> str:
        src = textwrap.dedent(src.expandtabs(2).strip("\n"))
        out: list[str] = []
        i, n = 0, len(src)
        line_start = True
        in_list = False      # last line was part of a list
        indent = ""          # indentation of the current list item content
        while i < n:
            c = src[i]
            if line_start:
                line_start = False
                m = re.match(r"[ \t]*", src[i:])
                ws = m.group(0)
                j = i + len(ws)
                level = len(ws) // 2
                hm = re.match(r"(=+)\s+(.*)", src[j:].split("\n", 1)[0])
                if hm:
                    out.append(self.heading(len(hm.group(1)) + offset,
                                            self.inline(hm.group(2))))
                    i = j + hm.end()
                    indent = ""
                    continue
                lm = re.match(r"([-+])\s+", src[j:])
                if lm:
                    marker = "-" if lm.group(1) == "-" else "1."
                    out.append("   " * level + marker + " ")
                    indent = "   " * (level + 1)
                    in_list = True
                    i = j + lm.end()
                    continue
                if src[j:j + 1] == "\n":
                    indent = ""
                    in_list = False
                elif in_list and not ws:
                    # Typst ends the list here; Markdown would continue it
                    out.append("\n")
                    in_list = False
                    indent = ""
                elif ws:
                    out.append(indent if indent else "")
                i = j
                continue
            if c == "\n":
                out.append("\n")
                i += 1
                line_start = True
                continue
            # comments
            if src.startswith("//", i) and (i == 0 or src[i - 1] in " \t\n"):
                j = src.find("\n", i)
                i = n if j < 0 else j
                continue
            if src.startswith("/*", i):
                j = src.find("*/", i)
                i = n if j < 0 else j + 2
                continue
            # math
            if c == "$":
                j = skip_math(src, i)
                body = src[i + 1 : j - 1]
                display = len(body) > 0 and body[0] in " \t\n" and body[-1] in " \t\n"
                out.append(self.math(body, display, indent))
                i = j
                continue
            # raw
            if c == "`":
                j = skip_raw(src, i)
                raw = src[i:j]
                if raw.startswith("```"):
                    body = raw[3:-3]
                    lang, _, code = body.partition("\n")
                    code = textwrap.dedent(code.rstrip())
                    lang = lang.strip() or self.default_lang
                    block = f"```{lang}\n{code}\n```"
                    out.append("\n\n" + textwrap.indent(block, indent) + "\n\n")
                else:
                    out.append(raw)
                i = j
                continue
            # escapes
            if c == "\\":
                nxt = src[i + 1] if i + 1 < n else "\n"
                if nxt in " \t\n":
                    out.append("<br>")
                    i += 1
                else:
                    out.append("\\" + nxt if nxt in "*_#$[]<>`|" else nxt)
                    i += 2
                continue
            # code
            if c == "#":
                res, j = self.code(src, i + 1, offset, depth, indent)
                out.append(res)
                i = j
                continue
            if c == "*":
                out.append("**")
                i += 1
                continue
            if c == "_":
                out.append("*")
                i += 1
                continue
            if c == "~":
                out.append("\u00a0")
                i += 1
                continue
            if src.startswith("---", i):
                out.append("—")
                i += 3
                continue
            if src.startswith("--", i) and not src.startswith("-->", i):
                out.append("–")
                i += 2
                continue
            if c == "<":
                out.append("&lt;")
                i += 1
                continue
            out.append(c)
            i += 1
        return "".join(out)

    def inline(self, src: str) -> str:
        """Markup on a single line (titles, table cells)."""
        md = self.markup(src)
        md = re.sub(r"\n\s*```math\n(.*?)\n\s*```\n", lambda m: " $`" + m.group(1).strip() + "`$ ", md, flags=re.S)
        return re.sub(r"\s*\n\s*", " ", md).strip()

    def math(self, body: str, display: bool, indent: str = "") -> str:
        tex, multiline = math_to_latex(body)
        if display:
            block = f"```math\n{tex}\n```"
            return "\n\n" + textwrap.indent(block, indent) + "\n\n"
        return f"$`{tex}`$"

    # ── code expressions ──────────────────────────────────────────────
    def code(self, src: str, i: int, offset: int, depth: int, indent: str):
        """Handle `#...` at src[i] (just after '#'). Returns (md, end)."""
        m = IDENT_RE.match(src, i)
        if not m:
            return "#", i
        name = m.group(0)
        if name in ("set", "show", "let", "import", "include"):
            j = i
            while j < len(src) and src[j] != "\n":
                if src[j] in "({":
                    j = skip_code(src, j)
                elif src[j] == "[":
                    j = skip_content(src, j)
                elif src[j] == '"':
                    j = skip_string(src, j)
                else:
                    j += 1
            return "", j
        if name.startswith("sym."):
            return SYM_TEXT.get(name[4:], ""), m.end()
        call = parse_call(src, i)
        return self.call(call, offset, depth, indent), call.end

    def value(self, v: str, offset=0, depth=0) -> str:
        """A code value used as content: string, [content], $math$, call, a + b."""
        parts = split_top(v, "+") if "+" in v else [v]
        res = []
        for p in parts:
            p = p.strip()
            if p.startswith('"'):
                res.append(unquote(p))
            elif p.startswith("["):
                res.append(self.markup(p[1:-1], offset, depth))
            elif p.startswith("$"):
                body = p[1:-1]
                res.append(self.math(body, body[:1] in " \n" and body[-1:] in " \n"))
            elif IDENT_RE.match(p):
                call = parse_call(p, 0)
                res.append(self.call(call, offset, depth, ""))
            else:
                res.append(p)
        return "".join(res)

    def call(self, c: Call, offset: int, depth: int, indent: str) -> str:
        name = c.name
        body_src = c.bodies[-1] if c.bodies else None

        if name in ALERTS:
            if name == "example":
                title = "Exemplo"
                body_src = body_src if body_src is not None else (c.pos[0][1:-1] if c.pos else "")
            else:
                title = self.inline_value(c.pos[0]) if c.pos else ""
                if body_src is None and len(c.pos) > 1:
                    body_src = c.pos[1][1:-1]
            body = self.markup(body_src or "", offset, depth + 1).strip()
            return self.alert(ALERTS[name], title, body, depth)

        if name == "figure":
            if c.pos and "canvas(" in c.pos[0]:
                inner = self.render(c.pos[0])  # keep side-by-side drawings together
            else:
                inner = self.value(c.pos[0], offset, depth) if c.pos else ""
            cap = self.inline_value(c.named["caption"]) if "caption" in c.named else ""
            res = "\n\n" + inner.strip() + "\n"
            if cap and "$`" in cap:  # math does not render inside HTML tags
                res += f"\n*{cap}*\n"
            elif cap:
                res += f"\n<p align=\"center\"><em>{cap}</em></p>\n"
            return res + "\n"

        if name == "image":
            path = self.asset_path(unquote(c.pos[0]))
            width = c.named.get("width", "").strip()
            w = f' width="{width}"' if width.endswith("%") else ""
            return f'\n\n<p align="center"><img src="{path}"{w}></p>\n\n'

        if name == "canvas":
            return self.canvas(c)

        if name == "table":
            return self.table(c)

        if name in ("grid", "stack"):
            items = [p for p in c.pos if not re.match(r"^[a-z-]+\s*:", p)]
            return "\n\n" + "\n\n".join(self.value(p, offset, depth).strip() for p in items) + "\n\n"

        if name == "link":
            url = unquote(c.pos[0])
            text = self.inline(body_src) if body_src else url
            return f"[{text}]({url})"

        if name in ("h",):
            return " "
        if name in ("v", "pagebreak", "colbreak", "line", "place") and not c.bodies:
            return ""
        if name in ("strong",):
            return "**" + self.inline(body_src or unquote(_a(c.pos, 0))) + "**"
        if name in ("emph",):
            return "*" + self.inline(body_src or unquote(_a(c.pos, 0))) + "*"
        if name == "heading":
            lvl = int(c.named.get("level", "1"))
            return self.heading(lvl + offset, self.inline(body_src or ""))
        # align, text, box, block, smallcaps, ... : keep the content
        if body_src is not None:
            return self.markup(body_src, offset, depth)
        if c.pos:
            return self.value(c.pos[-1], offset, depth)
        return ""

    def inline_value(self, v: str) -> str:
        return re.sub(r"\s*\n\s*", " ", self.value(v)).strip()

    @staticmethod
    def alert(kind: str, title: str, body: str, depth: int) -> str:
        if depth == 0:
            head = f"> [!{kind}]\n> **{title}**\n>\n"
        else:  # GitHub alerts cannot be nested: plain titled quote instead
            head = f"> **{title}.**\n>\n"
        lines = [("> " + l) if l.strip() else ">" for l in body.split("\n")]
        return "\n\n" + head + "\n".join(lines) + "\n\n"

    def asset_path(self, p: str) -> str:
        if p.startswith("/"):
            full = (self.root / p.lstrip("/")).resolve()
        else:
            full = (self.cur_file.parent / p).resolve()
        return os.path.relpath(full, self.root)

    # ── tables ────────────────────────────────────────────────────────
    def table(self, c: Call) -> str:
        cols = c.named.get("columns", "1").strip()
        if cols.startswith("("):
            ncols = len(split_top(cols[1:-1]))
        else:
            ncols = int(cols) if cols.isdigit() else 1
        header, cells = None, []
        for p in c.pos:
            if p.startswith("table.header"):
                hc = parse_call(p, 0)
                header = [self.cell(x) for x in hc.pos]
            else:
                cells.append(self.cell(p))
        rows = [cells[k : k + ncols] for k in range(0, len(cells), ncols)]
        if rows and len(rows[-1]) < ncols:
            rows[-1] += [""] * (ncols - len(rows[-1]))
        if header is None:
            header, rows = (rows[0], rows[1:]) if rows else ([""] * ncols, [])
        md = ["| " + " | ".join(header) + " |", "|" + "---|" * ncols]
        md += ["| " + " | ".join(r) + " |" for r in rows]
        return "\n\n" + "\n".join(md) + "\n\n"

    def cell(self, v: str) -> str:
        return self.inline_value(v).replace("|", r"\|") if v.strip() != "[]" else ""

    # ── CeTZ canvas -> SVG ────────────────────────────────────────────
    def canvas(self, c: Call) -> str:
        args = ", ".join([*(f"{k}: {v}" for k, v in c.named.items()), *c.pos])
        return self.render(f"canvas({args})")

    def render(self, expr: str) -> str:
        """Compile a Typst code expression (drawing, grid of drawings) to SVG."""
        if not self.figures:
            return "\n\n*(figura)*\n\n"
        src = (
            f"{self.file_preamble}\n"
            "#set page(width: auto, height: auto, margin: 12pt, fill: white)\n"
            f"#{expr}\n"
        )
        digest = hashlib.sha1(src.encode()).hexdigest()[:10]
        self.fig_dir.mkdir(parents=True, exist_ok=True)
        out = self.fig_dir / f"fig-{digest}.svg"
        with tempfile.TemporaryDirectory() as td:
            tmp = Path(td) / "fig.typ"
            tmp.write_text(src, encoding="utf-8")
            r = subprocess.run(["typst", "compile", "--root", "/", str(tmp), str(out)],
                               capture_output=True, text=True)
        if r.returncode != 0:
            print(f"  ! figure failed in {self.cur_file.name}: {r.stderr.strip()[:300]}", file=sys.stderr)
            return "\n\n*(figura não convertida)*\n\n"
        self.fig_count += 1
        return f'\n\n<p align="center"><img src="{os.path.relpath(out, self.root)}"></p>\n\n'

    # ── files ─────────────────────────────────────────────────────────
    def include(self, path: Path, offset: int) -> str:
        self.cur_file = path
        src = path.read_text(encoding="utf-8")
        # preamble for standalone canvas rendering (imports + top-level lets)
        pre = []
        for m in re.finditer(r"^#(import|let)\b", src, re.M):
            j = m.start() + 1
            k = j
            while k < len(src) and src[k] != "\n":
                if src[k] in "({":
                    k = skip_code(src, k)
                elif src[k] == "[":
                    k = skip_content(src, k)
                elif src[k] == '"':
                    k = skip_string(src, k)
                else:
                    k += 1
            stmt = src[m.start():k]
            stmt = re.sub(r'#import\s+"(?!@)([^"]+)"',
                          lambda mm: f'#import "{(path.parent / mm.group(1)).resolve()}"', stmt)
            pre.append(stmt)
        self.file_preamble = "\n".join(pre)
        return self.markup(src, offset)


# ════════════════════════════════════════════════════════════════════════
#  notebook.typ
# ════════════════════════════════════════════════════════════════════════

def strip_line_comments(src: str) -> str:
    return "\n".join(l for l in src.split("\n") if not l.lstrip().startswith("//"))


def convert_notebook(nb_path: Path, out_path: Path, figures: bool) -> None:
    root = nb_path.parent
    conv = Converter(root, figures)
    if figures and conv.fig_dir.exists():
        shutil.rmtree(conv.fig_dir)
    src = strip_line_comments(nb_path.read_text(encoding="utf-8"))

    meta = {}
    pm = re.search(r"#show:\s*project\.with\(", src)
    if pm:
        call = parse_call(src, pm.start() + len("#show: "))
        meta = {k: unquote(v) for k, v in call.named.items()}

    body = []
    for m in re.finditer(r"#subject\(", src):
        call = parse_call(src, m.start() + 1)
        name = unquote(call.pos[0])
        lang = unquote(call.named.get("lang", '""'))
        conv.default_lang = {"riscv": "asm", "none": ""}.get(lang, lang)
        print(f"- {name}")
        body.append(conv.heading(1, name))
        for item in call.pos[1:]:
            inc = re.match(r'include\s+"([^"]+)"', item)
            if inc:
                body.append(conv.include(root / inc.group(1), 1))
            elif item.startswith("["):
                block, offset = item[1:-1], 1
                for line in block.strip().split("\n"):
                    line = line.strip()
                    hm = re.match(r"#heading\(level:\s*(\d+)\)\[(.*)\]", line)
                    om = re.match(r"#set heading\(offset:\s*(\d+)\)", line)
                    im = re.match(r'#include\s+"([^"]+)"', line)
                    if hm:
                        body.append(conv.heading(int(hm.group(1)), conv.inline(hm.group(2))))
                    elif om:
                        offset = int(om.group(1))
                    elif im:
                        body.append(conv.include(root / im.group(1), offset))

    md = "".join(body)
    md = re.sub(r"[ \t]+\n", "\n", md)
    md = re.sub(r"\n{3,}", "\n\n", md)
    md = re.sub(r"^((?:> ?)+)\n(?:\1\n)+", r"\1\n", md, flags=re.M)  # repeated empty quote lines
    md = re.sub(r"^((?:> )*)>\s*$", lambda m: m.group(0).rstrip(), md, flags=re.M)

    head = [f"# {meta.get('title', 'Notebook')}", ""]
    who = " · ".join(x for x in (meta.get("author"), meta.get("academic-year")) if x)
    if who:
        head += [f"**{who}**", ""]
    head += ["> Gerado automaticamente a partir de `notebook.typ` por `typst_to_md.py`. "
             "Edite os arquivos `.typ` e rode o script de novo.", "", "## Índice", ""]
    for level, title, slug in conv.toc:
        if level <= 2:
            head.append("  " * (level - 1) + f"- [{title}](#{slug})")
    out_path.write_text("\n".join(head) + "\n\n" + md.strip() + "\n", encoding="utf-8")
    print(f"Wrote {out_path} ({len(md.splitlines())} lines, {conv.fig_count} figures)")


def main():
    here = Path(__file__).resolve().parent
    ap = argparse.ArgumentParser(description="Convert the Typst notebook to Markdown.")
    ap.add_argument("-i", "--input", type=Path, default=here / "notebook.typ")
    ap.add_argument("-o", "--output", type=Path, default=here / "README.md")
    ap.add_argument("--no-figures", action="store_true", help="skip rendering CeTZ figures")
    a = ap.parse_args()
    convert_notebook(a.input.resolve(), a.output.resolve(), not a.no_figures)


if __name__ == "__main__":
    main()
