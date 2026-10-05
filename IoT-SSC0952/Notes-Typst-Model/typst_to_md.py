import re
import sys


def convert_math_content(content):
  # 1. Tratar cal(...) do Typst para \mathcal{...}
  content = re.sub(r"\bcal\(([^)]+)\)", r"\\mathcal{\1}", content)

  # 2. Tratar subscritos e sobrescritos com parênteses: _(...) -> _{...} e ^(...) -> ^{...}
  content = re.sub(r"_\s*\(([^)]+)\)", r"_{\1}", content)
  content = re.sub(r"\^\s*\(([^)]+)\)", r"^{\1}", content)

  # 3. Operadores lógicos e relacionais do Typst para LaTeX (usando strings brutas r"...")
  replacements = [
      (r"=>", r"\implies "),
      (r"<=", r"\le "),
      (r">=", r"\ge "),
      (r"!=", r"\neq "),
  ]

  for pattern, latex_op in replacements:
    # Se o padrão começa com \b, já é regex; senão, escapamos os símbolos literais
    if pattern.startswith(r"\b"):
      regex_pattern = pattern
    else:
      regex_pattern = r"\b" + re.escape(pattern) + r"\b"
    content = re.sub(regex_pattern, lambda m, l=latex_op: l, content)

  # 4. Funções matemáticas comuns (como log, ln, sin, cos, etc.)
  math_funcs = ["log", "ln", "sin", "cos", "tan", "sec", "csc", "cot", "lim", "max", "min"]
  for func in math_funcs:
    content = re.sub(r"\b" + func + r"\b", lambda m, f=func: f"\\{f}", content)

  return content


def convert_math(match):
  raw_content = match.group(1)
  content = convert_math_content(raw_content)

  # Regra de espaçamento: Se tiver quebra de linha ou espaços nas pontas, é bloco ($$...$$)
  if "\n" in content or content.startswith(" ") or content.endswith(" "):
    return f"$${content.strip()}$$"
  else:
    return f"${content.strip()}$"


def typst_to_markdown(typst_content):
  md = typst_content

  # 1. Tratar figuras e imagens: #figure(image(...), caption: [...]) -> ![caption](path)
  md = re.sub(
      r'#figure\(\s*image\("([^"]+)"(?:,\s*[^)]+)?\)\s*(?:,\s*caption:\s*\[(.*?)\])?\s*\)',
      lambda m: f"![]({m.group(1)})" if not m.group(2) else f"![{m.group(2)}]({m.group(1)})",
      md,
  )

  # Caso sobre alguma imagem avulsa sem figure
  md = re.sub(r'#image\("([^"]+)"(?:,\s*[^)]+)?\)', r"![](\1)", md)

  # 2. Conversão de matemática baseada na regra de espaçamento ($...$)
  md = re.sub(r"\$(.*?)\$", convert_math, md, flags=re.DOTALL)

  # 3. Títulos (= -> #, == -> ##, etc.)
  md = re.sub(r"^(=+)\s+(.+)$", lambda m: "#" * len(m.group(1)) + " " + m.group(2), md, flags=re.MULTILINE)

  # 4. Negrito (*texto* -> **texto**)
  md = re.sub(r"(?<!\*)\*(?!\*)(.*?)(?<!\*)\*(?!\*)", r"**\1**", md)

  # 5. Itálico (_texto_ -> *texto*)
  md = re.sub(r"\b_(.*?)_\b", r"*\1*", md)

  # 6. Links (#link("url")[texto] -> [texto](url))
  md = re.sub(r'#link\("([^"]+)"\)\[(.*?)\]', r"[\2](\1)", md)

  return md


def convert_file(input_path, output_path):
  with open(input_path, "r", encoding="utf-8") as f:
    content = f.read()

  converted = typst_to_markdown(content)

  with open(output_path, "w", encoding="utf-8") as f:
    f.write(converted)
  print(f"Convertido com sucesso: {output_path}")


if __name__ == "__main__":
  if len(sys.argv) < 3:
    print("Uso: python typst_to_md.py arquivo.typ arquivo.md")
  else:
    convert_file(sys.argv[1], sys.argv[2])
