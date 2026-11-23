#import "../lib.typ": *
#import "@preview/cetz:0.4.0"

// ── helpers locais ─────────────────────────────────────────────────────
// Fluxo horizontal de caixas: #flow[a][b][c]
#let flow(..steps) = align(center, block(breakable: false, {
  set text(size: 0.85em)
  steps.pos().map(s => box(
    stroke: 0.6pt + colors.primary,
    fill: colors.primary.lighten(92%),
    inset: (x: 6pt, y: 4pt),
    radius: 3pt,
    baseline: 25%,
  )[#s]).join(box(inset: (x: 3pt))[#text(fill: colors.primary)[$arrow.r$]])
}))

// Caixa de "atenção"
#let dica(body) = block(
  fill: rgb("#fff4d6"),
  stroke: (left: 3pt + rgb("#e0a100")),
  inset: 9pt,
  radius: 3pt,
  width: 100%,
)[#text(weight: "bold", fill: rgb("#a06f00"))[Atenção.] #body]

#let fig(path, w: 80%, cap) = figure(image(path, width: w), caption: cap)

#set table(stroke: 0.5pt + gray, inset: 5pt)
#show table.cell.where(y: 0): set text(weight: "bold")
#show table: set par(justify: false, leading: 0.65em)

= Visão geral do curso

- *Prof.* Marcelo G. Manzato. *Livros:* Manning, Raghavan & Schütze, _Introduction to IR_ (2008); Baeza-Yates & Ribeiro-Neto, _Recuperação de Informação_ (2ª ed.).
- *Notas:* $"MT" = 0.4 T_1 + 0.6 T_2$; #h(0.5em) $"MP" = 0.4 P_1 + 0.6 P_2$ (SUB substitui a menor entre P1 e P2); ME = média (nota do prof. + avaliação da comunidade).
- $"MF" = 0.3 "MT" + 0.6 "MP" + 0.1 "ME"$ se MT, MP, ME $>= 5$; senão $"MF" = min("MT", "MP", "ME")$.
- *Recuperação:* $"MR" >= 7.5 => "MF" = "MS" + "MR"\/2.5$; #h(0.3em) $5 <= "MR" < 7.5 => "MF" = 5$; #h(0.3em) $"MR" < 5 => "MF" = max("MS", "MR")$.

*Mapa mental da disciplina:*
#flow[Booleano][Probabilístico (BIM → BM25)][Vetorial (TF-IDF)][Avaliação][Indexação][Dicionários / tolerância][Semântica (embeddings, BERT)][Grafos / SPARQL][Híbrida, reranking, RAG][Web (PageRank)]

= Introdução (Aula 01)

== O que é RI

*RI* lida com *representação, indexação, busca, ranqueamento e avaliação* de itens de informação relevantes a uma *necessidade do usuário*. Itens: documentos, páginas Web, registros (semi)estruturados, mídia, entidades/grafos, respostas de sistemas generativos.

#flow[Tarefa do usuário][Necessidade de informação][Consulta (keywords)][Máquina de busca][Resultados][Refinamento ↺]

A descrição completa da necessidade *não* é uma boa consulta; ela é traduzida em *termos de indexação* que a sumarizam. Objetivo do sistema: recuperar o que é *relevante* ao usuário.

*Tipos de busca:* conhecida (item específico) · informacional (aprender) · exploratória (entender um domínio) · transacional (realizar ação) · conversacional (refinar iterativamente) · recomendação/descoberta (sem consulta explícita).

== Recuperação de dados × de informação

#table(
  columns: (1fr, 1fr),
  [Dados (ex.: BD relacional)], [Informação (ex.: busca na Web)],
  [Condições formalmente especificadas], [Necessidades ambíguas],
  [Correspondência exata], [Correspondência por relevância],
  [Resultado normalmente não ranqueado], [Resultado ranqueado],
  [Esquema definido], [Texto, mídia, metadados heterogêneos],
  [Correção lógica], [Utilidade/relevância para o usuário],
)
Hoje muitos sistemas combinam *filtros estruturados + ranqueamento* (ex.: "notebooks para ciência de dados" filtrando preço/memória e ordenando por relevância).

- *Estruturados:* tabelas; permitem intervalos e matching exato (`Salário < 60000 AND Gerente = Smith`).
- *Não estruturados:* texto livre; consultas por palavra-chave ou conceitos.
- *Semiestruturados:* quase nada é 100% não estruturado (título, bullets, campos) → `Título contém X AND Bullets contém Y`. Ex.: IMDb.
- *"Vs" dos dados:* volume, variedade, velocidade, veracidade, valor.
- *Web 1.0* documentos estáticos · *2.0* social/participativa · *3.0* semântica (Linked Data, ontologias, KGs, blockchain) · *4.0* inteligente/ubíqua (IoT, IA generativa, agentes, AR/VR).
- *Sobrecarga de informação* → RI e Sistemas de Recomendação são as principais ferramentas.

#table(
  columns: (1fr, 1fr),
  [Recuperação de Informação], [Recomendação],
  [Parte de uma consulta], [Pode operar sem consulta],
  [Necessidade momentânea / busca intencional], [Preferências e comportamento / descoberta],
  [Relevância consulta–item], [Utilidade usuário–item],
)
Desafios de RI: consulta curta/ambígua, intenção implícita, vocabulário diferente entre consulta e doc, relevância dependente de contexto, equilíbrio personalização × diversidade × privacidade. Os paradigmas estão convergindo.

#fig("images/arqclassica.png", w: 62%)[Arquitetura clássica: crawling → coleção → indexador → índice invertido; consulta → parsing/expansão → recuperação e ranqueamento.]

A *arquitetura moderna* separa: *offline* (coleta → limpeza/segmentação → representação → índice lexical BM25 + índice vetorial + metadados) e *online* (consulta → correção/expansão → recuperação híbrida → fusão → reranking neural → contexto top-k → LLM/RAG → resposta, com feedback/cliques).

== Linha do tempo (decore os marcos)

#table(
  columns: (auto, 1fr),
  [Anos 50], [Luhn, Garfield, Bagley, *Calvin Mooers* (cunhou "Information Retrieval"). *1955*: Allen Kent cria *precisão e revocação*.],
  [1962], [Cyril Cleverdon — estudos *Cranfield* (coleções + consultas + julgamentos de relevância).],
  [1963], [Becker & Hayes — primeiro livro de RI.],
  [Anos 60], [*Salton*: modelo vetorial e sistema *SMART*; *Spärck Jones*: *IDF*. 1968: 1º livro de Salton.],
  [1971], [Jardine & van Rijsbergen: *hipótese de agrupamento* ("docs próximos tendem a ser relevantes às mesmas consultas").],
  [1978], [1ª *ACM SIGIR* (Rochester, NY).],
  [1979], [Van Rijsbergen, _Information Retrieval_ (fundamentos probabilísticos, avaliação).],
  [1983], [Salton & McGill, _Intro. to Modern IR_ — vetorial + *cosseno*.],
  [1992 / 94–95 / 98], [*TREC* / *BM25* / Web com Google e *PageRank*.],
  [2005–10 / 2009 / 2013], [*Learning to rank* / MS LTR dataset / *Word2Vec*.],
  [2018 / 2019 / 2020], [*BERT* / BERT p/ reranking / *DPR* (recuperação densa) e *RAG*.],
  [2022–26], [Busca conversacional, recuperação generativa, sistemas híbridos, multimodais, agentes, avaliação com LLMs.],
)
Até o fim dos anos 80, RI era de bibliotecas e sistemas especializados; o que mudou tudo foi a *World Wide Web* (início dos anos 90). Índices historicamente: *rótulos* (tópicos) + *ponteiros* (para o doc). Arquivo antigo: Ebla (Síria, 3º milênio a.C.); Biblioteca de Alexandria (séc. III a.C.).

= Modelo Booleano (Aula 02)

== Modelo de RI (definição formal)

Um modelo de RI é a quádrupla $[D, Q, F, R(q_i, d_j)]$: $D$ = representações dos docs, $Q$ = representações das consultas, $F$ = arcabouço de modelagem, $R$ = função de ranqueamento.

#Highlight2("Modelo booleano como quádrupla")[
  $D$: vetores *binários* · $Q$: expressões booleanas · $F$: *álgebra booleana* · $R(q_i, d_j) = 1$ se o doc satisfaz a consulta, $0$ caso contrário.
]

== Pré-processamento (visão lógica do documento)

#flow[Tokenização][Stop words][Normalização][Lematização][Radicalização][Desambiguação]

- *Tokenização:* separar em tokens. Difícil: "São Carlos", "ICMC-USP", "R\$ 2.500,00", "não-linear", e-mails, "ChatGPT-5", emojis, URLs.
- *Stop words:* remover palavras muito comuns — *nem sempre desejável*: "ser ou não ser", "O Senhor dos Anéis", análise de sentimento.
- *Normalização:* minúsculas, Unicode, acentos, números/datas, hífen, pontuação, URLs/e-mails.
- *Lematização:* forma canônica (passa → passar, nossa → nosso, vai → ir). Exige *conhecimento morfológico* / dicionário.
- *Radicalização (stemming):* corta sufixos (passa → pass, sozinho → sozinh). O radical *não precisa ser palavra válida*. Lematização e stemming *não precisam ser usadas juntas*.
- *Desambiguação de sentido:* escolhe o significado no contexto (ex.: Babelfy: passar → bn:00091458v). *Não é obrigatória* para um índice simples.

#dica[Remover "não" de "Não gostei dos filmes de terror" *altera o significado*. Stemming típico: computação/computador/computacional → `comput` (carros→carro é normalização/lematização; fizeram→fazer é lematização).]

*Indexação por termos* — vantagens: simples, interpretável, eficiente, consultas transparentes, ótima p/ nomes e códigos. Desvantagens: *sinonímia e polissemia*, dependência lexical, consultas curtas/ambíguas, pouco contexto/semântica.

Vocabulário $V = {k_1, ..., k_t}$: conjunto dos $t$ termos distintos da coleção.

== Construção do índice invertido

#flow[pares (termo, docID)][*ordenar* por termo e depois docID][fundir repetidos][dicionário + postings (+ frequências)]

A ordenação é a *etapa fundamental* (e a mais custosa).

#align(center, table(
  columns: 3,
  [Termo (df)], [], [Postings (ordenadas por docID)],
  [Brutus (6)], [→], [1 2 4 11 31 45 173 174],
  [Caesar (8)], [→], [1 2 4 5 6 16 57 132],
  [Calpurnia (3)], [→], [2 31 54 101],
))

#table(
  columns: (1fr, 1fr),
  [O posting guarda...], [... e permite],
  [só docID], [consultas booleanas],
  [docID + frequência], [TF-IDF e BM25],
  [docID + posições], [consultas por *frase* e proximidade],
  [docID + campos], [busca em título/resumo/corpo],
)
Mais informação no posting → maior custo, mas consultas/ranqueamento mais sofisticados (*trade-off*).

#dica[Com índice só de docID + frequências, *não* dá para responder frase exata ("recuperação eficiente") — precisa de posições.]

== Consultas booleanas

Conectivos e *precedência*: 1. parênteses · 2. *NOT* ($not$) · 3. *AND* ($and$) · 4. *OR* ($or$).

#example[$t_1 = {1,2,3,6}$, $t_2 = {2,3,4}$, $t_3 = {3,4,5,6}$.

`t1 OR t2 AND NOT t3` $= t_1 union (t_2 inter overline(t_3)) = {1,2,3,6} union {2} = {1,2,3,6}$.]

*Interseção (AND)* com dois ponteiros andando juntos: se as listas têm tamanhos $x$ e $y$, custo *$O(x+y)$* — *exige listas ordenadas por docID*.

```python
def intersect(p1, p2):
    ans = []
    while p1 and p2:
        if p1.doc == p2.doc: ans.append(p1.doc); p1, p2 = p1.next, p2.next
        elif p1.doc < p2.doc: p1 = p1.next
        else: p2 = p2.next
    return ans
```
`Brutus AND NOT Caesar` e `OR` também saem em $O(x+y)$ com merge; `NOT Caesar` sozinho depende do tamanho da coleção ($O(N)$).

*Otimização:* em AND de vários termos, processe *do menor df para o maior* (termos raros primeiro reduzem resultados intermediários). Ex.: boolean (8k) AND retrieval (200k) AND model (600k) AND information (1M).

*Características:* doc = conjunto de palavras; resultado *determinístico*; correspondência lógica ≠ relevância. Usado em e-mail, bibliotecas, busca jurídica, filtros de lojas, Spotlight.

*Problemas:* não há satisfação parcial; *não ranqueia*; usuário precisa formular expressão booleana (geralmente simples demais); retorna *muitos ou poucos* documentos.

*Ainda é relevante?* Não é o ranqueador da Web, mas segue fundamental para *filtros* e arquiteturas híbridas (antes ou depois do ranking) e domínios que exigem controle explícito.

= Modelo Probabilístico (Aula 03)

Booleano pergunta "satisfaz?"; probabilístico pergunta *"qual a chance de ser relevante?"* — estima $P(R=1 | d, q)$ e ordena.

#Highlight1("Princípio do Ranqueamento Probabilístico (PRP)")[
  Ordenar os documentos por probabilidade de relevância decrescente:
  $ P(R|d_1, q) > P(R|d_2, q) > P(R|d_3, q) > dots $
  O PRP *não diz como calcular* a probabilidade, só o que fazer com ela; quem estima é o modelo (BIM, BM25...).
]

*Feedback de relevância:* mostra-se um ranking inicial, o usuário marca relevantes e o sistema refina as estimativas.

== Binary Independence Model (BIM)

- *Binary:* só presença/ausência ($w_(i,j) in {0,1}$).
- *Independence:* termos independentes dadas as classes relevante ($R$) / não relevante ($overline(R)$).
- Ranqueia pela *odds* de relevância: $"sim"(d_j, q) = P(R|d_j,q) \/ P(overline(R)|d_j,q)$. Ex.: $0.8\/0.2 = 4$ → 4× mais provável ser relevante.

Por Bayes + transformações:
$ "sim"(d_j, q) tilde sum_(k_i in q and k_i in d_j) [ log p_(i R)/(1 - p_(i R)) + log (1 - p_(i overline(R)))/p_(i overline(R)) ] $
com $p_(i R) = P(k_i = 1|R)$ e $p_(i overline(R)) = P(k_i = 1|overline(R))$.

#table(
  columns: 4,
  [Notação], [Significado], [Estimativa], [],
  [$N$], [nº de docs da coleção], [$p_(i R) = r_i\/R$], [],
  [$n_i$], [nº de docs com $k_i$], [$p_(i overline(R)) = (n_i - r_i)\/(N - R)$], [],
  [$R$], [nº de docs relevantes], [], [],
  [$r_i$], [relevantes que contêm $k_i$], [], [],
)

#Highlight2("Peso BIM (Robertson–Spärck Jones) com correção 0,5")[
  $ w_i = log ((r_i + 0.5)(N - n_i - R + r_i + 0.5))/((R - r_i + 0.5)(n_i - r_i + 0.5)) $
  O $+0.5$ evita probabilidade zero/razão infinita em células pequenas da tabela de contingência.

  *Sem feedback* (seleção inicial, $R = r_i = 0$):
  $ w_i = log (N - n_i + 0.5)/(n_i + 0.5) quad "(≈ IDF)" $
  $n_i < N\/2$ → peso positivo; $n_i = N\/2$ → zero; $n_i > N\/2$ → *negativo*. Para evitar negativo, remove-se o $n_i$ do numerador: $log (N+0.5)/(n_i+0.5)$.
]

#example[Coleção ($N=4$): $d_1$ "To do is to be. To be is to do." · $d_2$ "To be or not to be. I am what I am." · $d_3$ "I think therefore I am. Do be do be do." · $d_4$ "Do do do, da da da. Let it be, let it be."

Consulta "to do" ($n_"to"=2$, $n_"do"=3$), $log_10$.

*Seleção inicial* $log((N+0.5)\/(n_i+0.5))$: $d_1 = log(4.5\/2.5)+log(4.5\/3.5) = 0.364$; $d_2 = 0.255$; $d_3 = d_4 = 0.109$.

*Com feedback* ($d_1$, $d_3$ relevantes → $R=2$, $r_"to"=1$, $r_"do"=2$): $w_"to" = log((1.5)(1.5)\/(1.5)(1.5)) = 0$; $w_"do" = log((2.5)(1.5)\/(0.5)(1.5)) = log 5 = 0.699$. Scores: $d_1 = d_3 = d_4 = 0.699$, $d_2 = 0$.

$d_4$ empata sem ter sido marcado porque o BIM só vê *presença* de "do" (ignora frequência e tamanho).]

*Vantagens:* ranqueia por probabilidade de relevância; usa informação do próprio sistema. *Desvantagens:* não normaliza pelo tamanho; *ignora TF*; precisa de separação inicial relevantes/não relevantes.

== BM25

BM25 mantém a lógica probabilística e acrescenta o que o BIM ignora: *frequência com saturação* e *normalização pelo tamanho*.

#Highlight1("BM25")[
  $ "score"(d, q) = sum_(t in q) "IDF"(t) dot (f_(t,d) (k_1 + 1))/(f_(t,d) + k_1 (1 - b + b dot (|d|)/"avgdl")) $
  $ "IDF"(t) = ln(1 + (N - "df"(t) + 0.5)/("df"(t) + 0.5)) $
  - *Raridade* (IDF): termo raro ("quantum") pesa mais que comum ("computer").
  - *Frequência com saturação* ($k_1$): 5 ocorrências valem mais que 1, mas não 5×. $k_1$ menor → satura mais rápido; maior → TF influencia por mais tempo.
  - *Tamanho* ($b$): $b = 0$ ignora tamanho; $b = 1$ normalização total. Docs longos têm mais chance de conter qualquer termo.
  - Valores típicos: $k_1 = 1.2$, $b = 0.75$ (ajustados empiricamente).
]

#example[Mesma coleção, "to do", $k_1=1.2$, $b=0.75$.

$|d| = 10, 11, 10, 12$ → avgdl $= 10.75$; df(to)=2, df(do)=3.

TFs: $d_1$ (to 4, do 2), $d_2$ (to 2), $d_3$ (do 3), $d_4$ (do 3).

Resultado: $d_1 = 1.687 > d_2 = 0.947 > d_3 = 0.569 > d_4 = 0.547$.

BIM+feedback dava $d_1 = d_3 = d_4 > d_2$: o BM25 gera ordenação *mais informativa* ($d_3 > d_4$ só porque $d_4$ é maior).]

#dica[Doc A (100 palavras, tf=2) × Doc B (2000 palavras, tf=2) × Doc C (tf 15 e 12): A tende a ser favorecido sobre B pela normalização de tamanho, e o ganho de C *satura* (não é proporcional).]

#table(
  columns: (1fr, 1fr),
  [BIM], [BM25],
  [presença/ausência], [frequência do termo],
  [não conta repetições], [saturação da frequência ($k_1$)],
  [não considera tamanho], [normalização por tamanho ($b$)],
  [valoriza termos discriminativos], [IDF],
)

= Modelo Vetorial (Aula 04)

Cada documento (e consulta) é um vetor de pesos em $RR^t$: $arrow(d)_j = (w_(1,j), ..., w_(t,j))$, com $w_(i,j) = 0$ se $k_i in.not d_j$. Vetores reais: dezenas/centenas de milhares de dimensões e *extremamente esparsos*. Ex.: $V$={barato, bola, carro, faca, pessoa, seguro}, "carro barato" → $(1,0,1,0,0,0)$.

- $f_(i,j)$: frequência de $k_i$ em $d_j$. $F_i = sum_j f_(i,j)$: frequência total na coleção. $n_i$: nº de docs com $k_i$ (*$n_i <= F_i$*).
- Ex.: "do": $f = (2, 0, 3, 3)$, $F = 8$, $n = 3$.

#dica[Termo A aparece 1000× em 1 doc ($n=1$); termo B aparece 100× em 100 docs ($n=100$) → *A tem menor $n_i$* (logo maior IDF).]

== TF-IDF

TF = importância *local* (no doc); IDF = importância *global* (poder discriminativo).

#Highlight1("Pesos")[
  *Hipótese de Luhn:* peso proporcional à frequência. $"tf"_(i,j) = f_(i,j)$ ou, com saturação,
  $ "tf"_(i,j) = cases(1 + log f_(i,j) & "se" f_(i,j) > 0, 0 & "caso contrário") $
  $ "idf"_i = log N/n_i $
  $ w_(i,j) = (1 + log f_(i,j)) times log N/n_i quad ("se" f_(i,j) > 0, "senão" 0) $
  A base do log muda a escala, não a ordem (os slides usam $log_2$).
]

#dica[Na coleção "to do", o TF-IDF de *be* zera em todos os docs: "be" aparece nos 4 docs → $"idf" = log(4\/4) = 0$.]

Variações recomendadas (doc / consulta):
#table(
  columns: 3,
  [Esquema], [Peso do termo no doc], [Peso na consulta],
  [1], [$f_(i,j) dot log N/n_i$], [$(0.5 + 0.5 f_(i,q)/(max_i f_(i,q))) log N/n_i$],
  [2], [$1 + log f_(i,j)$], [$log(1 + N/n_i)$],
  [3], [$(1 + log f_(i,j)) log N/n_i$], [$(1 + log f_(i,q)) log N/n_i$],
)

*Normalização pelo tamanho:* docs longos acumulam peso. Divide-se pela norma: $|arrow(d)_j| = sqrt(sum_i w_(i,j)^2)$, $hat(d)_j = arrow(d)_j \/ |arrow(d)_j|$. Ex.: $d_1 = (3, 0.83, 4)$ → $|d_1| = 5.068$.

== Ranqueamento por cosseno

#Highlight1("Similaridade do cosseno")[
  $ "sim"(d_j, q) = cos theta = (arrow(d)_j dot arrow(q))/(|arrow(d)_j| |arrow(q)|) = (sum_i w_(i,j) w_(i,q))/(sqrt(sum_i w_(i,j)^2) sqrt(sum_i w_(i,q)^2)) $
  Numerador: *alinhamento*; denominador: *remove o efeito da magnitude*. Como $w >= 0$: $0 <= "sim" <= 1$.
]
- Permite *casamento parcial*; pesos não binários; termos assumidos *independentes*.
- Ex. "to do": $d_1 = 0.660$, $d_2 = 0.408$, $d_3 = 0.118$, $d_4 = 0.058$.

#dica[$d_1 = (10,10)$, $d_2 = (1,1)$, $q = (1,1)$ → *mesma similaridade* (cosseno só olha direção).]

#example[(IIR §6.4) Doc "car insurance auto insurance", consulta "best car insurance", $N = 10^6$; df: auto 5000, best 50000, car 10000, insurance 1000 → idf ($log_10$): 2.3, 1.3, 2.0, 3.0.

*Insurance* deve contribuir mais (maior idf + aparece 2× no doc).

Com lnc (doc: $1+log"tf"$, cosseno) e ltc na consulta sem normalizar: doc ≈ (0.52, 0, 0.52, 0.68), consulta (0, 1.3, 2.0, 3.0) → *score ≈ 3.08*.]

*Vantagens:* ponderação melhora resultados; casamento parcial; ranking por grau de similaridade; normalização já embutida no cosseno. *Desvantagens:* independência dos termos; *polissemia e sinonímia*; ignora ordem/posição; vocabulário enorme e esparso.

#table(
  columns: (1fr, 1fr),
  [Modelo vetorial], [BM25],
  [TF logarítmico], [TF com saturação parametrizada],
  [IDF], [IDF probabilístico],
  [Normalização pelo cosseno], [Normalização explícita por comprimento],
  [Similaridade entre vetores], [Framework probabilístico],
)

*Limitação principal:* "automóvel econômico" × "carro de baixo consumo" — pouca/nenhuma sobreposição lexical, mas mesmo significado → *embeddings*:
#table(
  columns: (1fr, 1fr),
  [Vetorial (TF-IDF)], [Embeddings],
  [1 dimensão por termo; alta dimensionalidade], [dimensões latentes aprendidas (poucas centenas)],
  [esparso; correspondência lexical], [denso; proximidade semântica],
  [interpretável por termo], [menos interpretável],
)

= Avaliação (Aula 05)

Sem avaliação sistemática não dá para saber o quão bem o sistema funciona nem comparar sistemas objetivamente.

*Níveis:* *offline* (P, R, MAP, MRR, nDCG) · *estudos com usuários* (satisfação, esforço, tempo) · *online* (cliques, CTR, A/B testing, interleaving).

*Coleção de referência:* documentos $D$ + necessidades de informação $I$ + *julgamentos de relevância (qrels)* para pares $[i_m, d_j]$ — *binários* ou *graduados*, feitos por humanos/especialistas. Ex.: Cranfield, TREC, MS MARCO, BEIR, Natural Questions.

*Treino/validação/teste:* teste *nunca* escolhe modelo/hiperparâmetros; separar *por consultas* (não por linhas de resultado). BM25: validação escolhe $k_1$, $b$; modelo neural: treino aprende pesos, validação escolhe arquitetura/LR.

== Precisão, revocação, F1

#Highlight1("Definições")[
  $R$ = relevantes, $A$ = resposta do sistema.
  $ "Revocação" = (|R inter A|)/(|R|) quad quad "Precisão" = (|R inter A|)/(|A|) quad quad F_1 = 2 (P dot R)/(P + R) $
]
São complementares (alta P/baixa R ou vice-versa). Assumem que todo $A$ foi examinado; num ranking, P e R variam conforme o usuário desce a lista → *curva P×R*.

*Interpolação (11 níveis $r_j in {0, 0.1, ..., 1}$):*
$ P(r_j) = max_(forall r | r_j <= r) P(r) $
*Média sobre consultas:* $overline(P)(r_j) = sum_(i=1)^(N_q) P_i (r_j)\/N_q$.

#example[$R_1 = {d_3, d_5, d_9, d_25, d_39, d_44, d_56, d_71, d_89, d_123}$.

Ranking: 1 *$d_123$*, 2 $d_84$, 3 *$d_56$*, 4 $d_6$, 5 $d_8$, 6 *$d_9$*, 7 $d_511$, 8 $d_129$, 9 $d_187$, 10 *$d_25$*, 11–14 não rel., 15 *$d_3$*.

Pontos (R, P): (10%, 100%), (20%, 66.6%), (30%, 50%), (40%, 40%), (50%, 33.3%); revocação máxima 50%.

Para $q_2$ ($R_2 = {d_3, d_56, d_129}$, relevantes nas posições 3, 8, 15): (33.3%, 33.3%), (66.6%, 25%), (100%, 20%).

Média interpolada ($q_1, q_2$): 66.6, 66.6, 49.9, 41.6, 32.5, 29.1, 12.5, 10, 10, 10, 10.]

*Problemas de P×R:* revocação exige conhecer todos os relevantes; às vezes uma medida única é melhor; ignora interatividade (avaliação em lote).

== Métricas de ranking

#Highlight2("P@K, Hit@k, AP/MAP, MRR")[
  - *P\@K:* precisão nos $K$ primeiros (na Web, revocação alta importa pouco). Ex. $q_1$: P\@5 = 40%, P\@10 = 40%.
  - *Hit\@k* (Success): 1 se existe ao menos um relevante no top-k (entidade, QA, RAG).
  - *AP:* média das precisões *nas posições dos relevantes* (relevante não recuperado conta 0):
  $ "AP"(q) = 1/(|R_q|) sum_(k=1)^N "P@"k dot "rel"(k) quad quad "AP@"K(q) = 1/(min(|R_q|, K)) sum_(k=1)^K "P@"k dot "rel"(k) $
  $ "MAP" = 1/(|Q|) sum_q "AP"(q) $
  Ex. $q_1$: $"AP" = (1 + 0.66 + 0.5 + 0.4 + 0.33)\/10 = 0.28$; $"AP@"5 = (1 + 0.66)\/5 = 0.332$.
  - *MRR:* foco no *primeiro* relevante. $"RR"(q) = 1\/"rank"_q$, $"MRR" = 1/(|Q|) sum_q "RR"(q)$. Ex.: posições 1, 4, 2 → $(1 + 0.25 + 0.5)\/3 = 0.583$.
]

#Highlight1("DCG e nDCG (relevância graduada)")[
  Ganho $= 2^("rel") - 1$ (rel 0,1,2,3 → 0,1,3,7). Desconta posições baixas:
  $ "DCG@"k = sum_(i=1)^k (2^("rel"_i) - 1)/(log_2(i + 1)) quad quad "nDCG@"k = ("DCG@"k)/("IDCG@"k) $
  IDCG = DCG do ranking ideal (ordenado por relevância). nDCG ≈ 1 → quase ideal; ≈ 0 → ruim.

  Ex.: rel $[3,0,2,1,0]$ → $"DCG@"5 = 7 + 0 + 3\/2 + 1\/log_2 5 = 8.93$; ideal $[3,2,1,0,0]$ → $"IDCG@"5 = 7 + 3\/log_2 3 + 1\/2 = 9.39$; $"nDCG" = 0.95$.
]
nDCG: considera graus de relevância e posição, permite avaliar só o top-N e penaliza relevantes fora do topo; porém julgamentos graduados são *mais caros*. Rankings $[3,2,1,0,0]$ e $[0,0,1,2,3]$ têm os mesmos relevantes, mas o primeiro é melhor.

*Além da relevância:* novidade, diversidade, cobertura, serendipidade, satisfação, esforço (importantes em recomendação e busca exploratória).

#example[*Exercício do slide.* 100 docs, 4 relevantes; ranking R,N,R,N,R,R,N,N,N,N; graus 2,0,3,0,3,1,0,0,0,0.

Pontos: (25%, 1), (50%, 0.667), (75%, 0.6), (100%, 0.667) → interpolado: $r = 0, 0.1, 0.2$: *1.0*; $r = 0.3 ... 1.0$: *0.667*.

$"AP@"3 = (1 + 2\/3)\/3 = 0.556$ (= MAP\@3 com 1 consulta) · P\@5 $= 3\/5 = 0.6$ · MRR $= 1$.

Ganhos $[3,0,7,0,7]$ → DCG\@5 $= 3 + 3.5 + 7\/log_2 6 = 9.21$; ideal $[7,7,3,1,0]$ → IDCG\@5 $= 7 + 4.42 + 1.5 + 0.43 = 13.35$ → *nDCG\@5 ≈ 0.69*.]

= Indexação (Aula 07)

*Motivação:* $N = 10^6$ docs × 1000 palavras × 6 bytes = 6 GB; $M = 500"k"$ termos → matriz termo-doc de $500"k" times 1"M" = 5 dot 10^11$ células com no máx. $10^9$ não nulas → *extremamente esparsa* → *índice invertido*.

- Postings de tamanho variável: em *disco*, alocação *sequencial* é melhor; em *memória*, *encadeada* (inserir doc 14 em Caesar).
- Pipeline: #flow[documentos][Tokenizer][Módulo linguístico (PT, EN...)][Indexer][Índice invertido]
- Estágios: tokenização (John's, state-of-the-art), normalização (U.S.A. = USA), stemming (authorize/authorization), stop words.
- Guardar *df no dicionário* serve para *otimizar consultas*.

== Otimização de consultas

- AND de $n$ termos: processar em *ordem crescente de df*. Ex.: `(Brutus AND Calpurnia) AND Caesar`.
- Com ORs: estimar o tamanho de cada OR pela *soma das dfs* (conservador, pois $|A union B| <= |A| + |B|$) e processar em ordem crescente.

#example[`(tangerine OR trees) AND (marmalade OR skies) AND (kaleidoscope OR eyes)`

Somas = 363.465, 379.571, 300.321

Ordem: *(kaleidoscope OR eyes)*, depois *(tangerine OR trees)*, depois *(marmalade OR skies)*.]

== Processamento no modelo vetorial e BM25 (term-at-a-time)

```python
Scores[N] = 0; Length[N]           # Length = norma de cada doc
for termo i in q:
    calcular w_iq; recuperar posting list de i
    for (docID, tf) in postings:
        Scores[docID] += w_i,docID * w_iq
for docID: Scores[docID] /= Length[docID]
return top-k de Scores
```
Ex. "Brutus Caesar" ($N=5$): ranking final *4, 5, 1*.

```python
for termo t in q:                  # BM25
    recuperar postings de t; calcular IDF(t)
    for (docID, tf) in postings:
        s = IDF(t) * tf*(k1+1) / (tf + k1*(1 - b + b*|d|/avgdl))
        Scores[docID] += s
```
O índice invertido não pertence a um modelo: serve Booleano, Vetorial e BM25.

== Construção em larga escala

Construir tudo em memória não escala → *ordenação externa*.

#Highlight2("BSBI — Blocked Sort-Based Indexing")[
  + Mapeia termo → *termID* (dicionário global em memória).
  + Divide a coleção em blocos iguais
  + Carrega bloco na RAM e gera os pares (termID, docID)
  + Ordena esses pares em memória
  + Junta os repetidos e monta as posting lists só daquele bloco (índice invertido parcial).
  + *Merge:* abre todos os blocos, junta as listas (tendo em mente que estão ordenadas) e grava em disco.
]

#example[Bloco 1: $d_1$ "carro azul", $d_2$ "carro carro seguro", $d_3$ "seguro barato"

Bloco 2: $d_4$ "carro elétrico", $d_5$ "seguro elétrico elétrico", $d_6$ "azul barato"

#v(10pt)

IDs: carro 1, azul 2, seguro 3, barato 4, elétrico 5.

#v(10pt)

Bloco 1 ordenado: 

- (1,1)(1,2)(1,2)(2,1)(3,2)(3,3)(4,3) (termID, docID)
- 1:[(1,1),(2,2)], 2:[(1,1)], 3:[(2,1),(3,1)], 4:[(3,1)]. (termID: [(docID, tf)])

#v(10pt)

Final: carro [(1,1),(2,2),(4,1)] · azul [(1,1),(6,1)] · seguro [(2,1),(3,1),(5,1)] · barato [(3,1),(6,1)] · elétrico [(4,1),(5,2)].]

#Highlight2("SPIMI — Single-Pass In-Memory Indexing")[

  Utilizado quando a coleção não cabe na memória.

  + Lê um token (term, docID)
  + Se o termo não está no dicionário do bloco, cria uma entrada com uma posting list vazia. *Usa o próprio termo, sem termID*.
  + Acrescenta docID no fim da posting list desse termo, ou soma 1 no tf se o docID já for o último da lista.
  + Quando a memória enche, ordena só os termos do dicionário, grava o bloco em disco e começa um bloco novo com o dicionário vazio.
  + No fim, faz merge de todos os blocos (igual BSBI)
]

#table(
  columns: 3,
  [], [BSBI], [SPIMI],
  [Entrada intermediária], [pares (termID, docID)], [termos inseridos diretamente],
  [Ordenação], [todos os pares do bloco], [só os termos do dicionário],
  [Postings], [após ordenar os pares], [construídas dinamicamente],
  [Dicionário], [mapeamento termo→ID global], [criado dinamicamente],
  [Memória], [mais overhead de pares], [uso mais direto],
)
Ambos geram *índices parciais* e precisam de *merge final*.

== Indexação distribuída (MapReduce, Google)

É a mesma ideia do BSBI/SPIMI, mas cada pedaço é processado numa máquina diferente, ao mesmo tempo. Para uma coleção do tamanho da Web, isso é o ideal.

- *Mestre* - Coordena tudo. Não indexa nada, só distribui tarefas e acompanha quem terminou.
- *Trechos (splits)* - Pedaços da coleção (assim como blocos)
- *Parsers* - Máquinas que lêem documentos e geram pares (termo, docID). Essa fase é o *map*
- *Inversores* - Máquinas que juntam os pares e montam as posting lists. Essa fase é o *reduce*.

#flow[Mestre atribui trecho][*Parser* (map): emite (termo, doc)][grava em $j$ partições por faixa de letras (a–f, g–p, q–z)][*Inversor* (reduce): coleta 1 partição, ordena, gera postings]

== Atualização e compressão

- *Atualização incremental:* índice *principal* grande e estável + índice *auxiliar* pequeno com novidades; consulta os dois; merge periódico gera nova versão.
- *Inserção* → no auxiliar. *Alteração* = remoção da versão antiga + inserção da nova.
- *Deleção lógica:* marca como deletado (barato); *física:* espaço recuperado depois, no merge/compactação.
- *Compressão:* menos espaço, menos transferência, melhor cache, consultas potencialmente mais rápidas.
  - *Gap encoding:* `[100, 105, 106, 130]` → `[100, 5, 1, 24]`. A ideia é guardar a diferença entre docIDs consecutivos em vez do docID em si.
  - *Variable byte:* nº variável de bytes por inteiro.

= Dicionários e Tolerância (Aula 08)

== Processamento linguístico

Decisões de design: formato (pdf, html...), idioma, codificação (UTF-8, ISO-8859-1), múltiplos idiomas/formatos; *o que é um documento?* (arquivo, e-mail, grupo, parágrafo).

#Highlight2("Token × Tipo × Termo")[
  *Token:* ocorrência de uma sequência de caracteres. *Tipo:* classe de tokens iguais. *Termo:* tipo incluído no dicionário. \
  "to sleep perchance to dream" → *5 tokens*, *4 tipos*, *3 termos* (sem a stop word "to").
]

- Casos difíceis: Finland's, Hewlett-Packard, San Francisco (expressões costumam ir para outra camada); números/datas (05/11/2020, PGP keys, telefones) — sistemas antigos não indexavam, mas são úteis.
- Idiomas: francês L'ensemble; alemão compostos (precisa *divisor de compostos*); chinês/japonês sem espaços (japonês mistura katakana, hiragana, kanji, romaji); árabe/hebraico RTL com trechos LTR. *Não há tokenização única para todas as línguas.*
- *Stop words:* tendência atual é *manter* na indexação.
- *Normalização:* classes de equivalência (U.S.A., USA → USA; anti-discriminatory → antidiscriminatory). *Accent folding* (résumé/resume) depende da língua — estratégia: manter forma original + forma normalizada. *Case folding* (exceção: nomes próprios; US × us, Apple × apple).
- *Lematização* (dicionário léxico): am, are, is → be; "the boy's cars are different colors" → "the boy car be different color".
- *Radicalização* (Porter, Snowball, Lovins): connect/connected/connection → connect. studies → *studi* (stem) × *study* (lema). Melhora revocação em algumas consultas e piora precisão em outras.

#dica[University, universe, universal → mesmo radical: recupera docs *semanticamente diferentes* → perda de *precisão*.]

== Estruturas de dados para o dicionário

O dicionário guarda termo, df e ponteiro para a posting. 

Requisitos: busca exata, por *prefixo* (hyp\*), atualização, busca *aproximada* (retrival → retrieval).

#table(
  columns: 3,
  [Estrutura], [Vantagens], [Desvantagens],
  [Hashtable], [lookup $O(1)$], [variantes da mesma palavra (judgment/judgement), *sem busca por prefixo*, crescer exige *rehashing*],
  [Array ordenado (char[20] + int + ponteiro = 32 B)], [simples, busca binária], [atualização (inserir/remover)],
  [Árvores (binária, B, Trie, Patricia)], [*resolve prefixo*], [mais lento: $O(log M)$ balanceada, $O(L)$ Trie; rebalancear é caro (B-tree faz sozinha)],
)
*Prefix B-tree:* chaves são o *menor prefixo que distingue* as chaves do nível abaixo (não precisa ser prefixo do termo); nós com nº variável de chaves; folhas guardam termos + dados.

== Correção ortográfica

*Para que serve:*
- Corrigir a *consulta* do usuário ("Você quis dizer…?"). É o uso principal.
- Normalizar/enriquecer o *índice*, sempre preservando o termo original.

*Dois casos:*
- *Palavra isolada:* olha cada termo sozinho. Pega "retrival", que não existe no dicionário.
- *Sensível ao contexto:* olha os vizinhos. Necessário quando o erro gera *outra palavra válida*: em "I flew form São Paulo", _form_ existe, então a correção isolada não percebe nada.

=== Medindo a distância entre palavras

- *Edit distance (Levenshtein):* número mínimo de inserções, remoções e substituições de um caractere para transformar uma palavra na outra. kitten → sitting = *3* (k→s, e→i, +g).
- *Weighted edit distance:* cada operação tem um peso diferente. Ex.: trocar letras de *teclas vizinhas* custa menos, porque é um erro de digitação mais provável.

*Problema:* comparar a consulta com *todo* o vocabulário (força bruta) é caro demais, já que são milhões de termos e a edit distance é $O(|a| dot |b|)$ por par.
- Heurística simples: só comparar com termos que começam com a mesma letra. É fraca: falha se o erro estiver na 1ª letra.
- *Solução melhor:* usar n-gramas como *filtro barato* para achar poucos candidatos e só então calcular a edit distance neles.

=== Filtro com n-gramas

*Bigramas* de uma palavra: pares de letras consecutivas. Com marcadores de início/fim (`$`), "teacher" → `$t, te, ea, ac, ch, he, er, r$`.

*Índice de n-gramas:* um índice invertido em que o "termo" é o bigrama e a posting list são as *palavras do vocabulário* que o contêm. Ex.: `lo` → alone, lore, sloth. É construído uma vez, junto com o dicionário.

Intuição: palavras parecidas compartilham muitos bigramas. Para medir *quanto* compartilham, usa-se Jaccard.

#Highlight1("Coeficiente de Jaccard")[
  $ J(X, Y) = (|X inter Y|)/(|X union Y|) $
  Vai de 0 (nenhum bigrama em comum) a 1 (mesmos bigramas). Dividir pela união penaliza palavras muito maiores, que casariam muitos bigramas só por serem longas.

  - lord {lo, or, rd} × ordinary {or, rd, di, in, na, ar, ry}: $2\/8 = 0.25$.
  - lord × lore {lo, or, re}: $2\/4 = 0.5$ → mais parecidas.

  Atalho: $|X union Y| = |X| + |Y| - |X inter Y|$. Como o índice já dá o nº de casamentos ($|X inter Y|$), não é preciso montar os conjuntos.
]

*Algoritmo (cada etapa elimina candidatos antes da próxima, que é mais cara):*
+ Quebrar a consulta em bigramas.
+ Buscar cada bigrama no índice de n-gramas e contar, para cada termo retornado, *quantos bigramas casaram*.
+ Manter os termos com nº de casamentos ≥ *limiar 1* (corte grosso).
+ Calcular Jaccard e manter os com $J$ ≥ *limiar 2* (corte que considera o tamanho).
+ Calcular a *edit distance* só nos sobreviventes e sugerir o de menor distância.

#example[
  $q$ = retrival → 7 bigramas: re, et, tr, ri, iv, va, al. Limiar 1 = 4, limiar 2 = 0,44.

  *Passo 3 — casamentos:* retrieval 6, revival 4, trivial 4, arrival 4, retrieve 4, retinal 3 (cai).

  *Passo 4 — Jaccard* (união = 7 + nº de bigramas do termo − casamentos):
  - retrieval (8 bigramas): $6\/(7+8-6) = 6\/9 = 0.667$
  - revival, trivial, arrival (6 bigramas cada): $4\/(7+6-4) = 4\/9 = 0.444$ (passam no limite)
  - retrieve (7 bigramas): $4\/(7+7-4) = 4\/10 = 0.40$ (cai)

  *Passo 5 — edit distance:* retrieval *1* (inserir "e"), revival 2, trivial 3, arrival 3.

  → *"Você quis dizer: retrieval?"*
]

=== Correção sensível ao contexto

Para "flew form São Paulo":
+ Para *cada termo*, buscar as correções próximas (pelo método acima): flew → flea, fled…; form → from, fore…
+ Gerar frases trocando *um termo por vez*: "flew *from*", "*fled* form", "*flea* form"…
+ Executar cada variante e sugerir a que retorna *mais resultados*.

*Otimização:* executar todas as variantes é caro. Em vez disso, consultar quais *biwords* (pares de palavras) são mais frequentes na coleção ou nos *logs de consultas*: "flew from" é muito mais comum que "flew form" → sugere "from".

= Recuperação Semântica e Modelos de Linguagem (Aula 09)

Modelos lexicais (BM25) *não estão obsoletos*; a semântica tenta aproximar pelo *significado*. Problema central: "carro barato" × "veículo de baixo custo".

- *Vocabulary mismatch:* dor de cabeça/cefaleia, notebook/computador portátil, demissão/desligamento.
- *Sinonímia:* palavras diferentes, mesmo conceito → lexical *perde relevantes* → *falsos negativos*, baixa *revocação*.
- *Polissemia:* mesma palavra, vários sentidos (banco) → *falsos positivos*, baixa *precisão*.
- *Lacuna semântica:* distância entre as palavras da consulta e a intenção real ("remédio para dor de cabeça forte" → "tratamento de enxaqueca").

#table(
  columns: (1fr, 1fr),
  [Busca lexical], [Busca semântica],
  [compara termos (TF, IDF, BM25)], [compara significados (embeddings)],
  [índice invertido], [índice vetorial],
  [nomes, códigos, termos raros], [paráfrases e sinônimos],
  [mais interpretável], [menos interpretável],
)

== Modelos de linguagem

Representam regularidades da língua: probabilidade de uma sequência (não precisa ser neural).
$ P(w_1, ..., w_n) = product_(i=1)^n P(w_i | w_1, ..., w_(i-1)) $
*n-gramas:* unigrama $P(w_i)$, bigrama $P(w_i|w_(i-1)) = f(w_(i-1), w_i)\/f(w_(i-1))$, trigrama $P(w_i | w_(i-2), w_(i-1))$. Mais contexto → mais dados necessários.

#example[Corpus "o gato dorme", "o gato come", "o cachorro dorme" (9 palavras).

Unigrama: $P(o)=3\/9$, $P("gato")=2\/9$, $P("dorme")=2\/9$ → "o gato dorme" $approx 0.0165$.

Bigrama: $P("gato"|o) = 2\/3$, $P("dorme"|"gato") = 1\/2$ → $approx 0.111$ (trigrama: idem).]

#Highlight2("Query Likelihood Model (QLM)")[
  Ranqueia pela chance de o doc "gerar" a consulta:
  $ P(q|d) = product_(i=1)^m P(q_i | d), quad log P(q|d) = sum_i log P(q_i|d) $
  *Suavização* (evita zeros), mistura doc + coleção:
  $ P(w|d) = (1 - lambda) P(w|d) + lambda P(w|C) $
]

#example[
"banco de dados"

- $d_1$ "Curso de banco de dados relacional" → $P(q|d_1) = 1/6 dot 2/6 dot 1/6 approx 0.00926$
- $d_2$ "O banco oferece dados de investimentos" → $P(q|d_1) = 1/6 dot 1/6 dot 1/6 approx 0.00463$. Com bigramas, $d_2$ zera ($P("de"|"banco") = 0$)
]

Limitação dos clássicos (QLM, vetorial): *só evidência lexical*; sem sinônimos, paráfrases ou contexto.

== Embeddings

*Problema do BoW/TF-IDF:* cada termo é uma dimensão independente. "carro" e "automóvel" são tão diferentes quanto "carro" e "banana", então uma consulta com um não acha documentos com o outro.

#v(10pt)

*Representação distribuída (embedding):* cada palavra vira um *vetor denso* de poucas centenas de dimensões (carro → [0.21, −0.43, 0.72, ...]), aprendido de forma que *palavras com significado parecido fiquem próximas* no espaço. Similaridade = *cosseno* entre os vetores.

#v(10pt)

*Hipótese distribucional:* "You shall know a word by the company it keeps". Palavras que aparecem nos mesmos contextos têm significados parecidos. "carro" e "automóvel" aparecem perto de "dirigir", "motor", "estacionar" → acabam com vetores próximos.

=== Word2Vec

Treina uma rede simples numa tarefa de "adivinhar palavras" a partir de uma janela de texto. Os vetores são o subproduto do treino.
- *CBOW:* contexto → palavra. "o \_\_\_ freou no sinal" → carro.
- *Skip-gram:* palavra → contexto. Dado "carro", prever "freou", "sinal"… (aprende $P(k_i | k_j)$ com os pares da janela).

*Propriedade surpreendente:* relações viram *direções* no espaço, então dá para fazer aritmética:
- $"king" - "man" + "woman" approx "queen"$ (direção "gênero")
- $"Paris" - "France" + "Italy" approx "Rome"$ (direção "capital de")

*Limitação:* *um vetor fixo por palavra*. "banco" tem o mesmo vetor em "sacar dinheiro no banco" e "sentar no banco da praça", uma mistura dos dois sentidos.

=== BERT

Resolve a limitação: gera embeddings *contextuais*. O vetor de "banco" é calculado a partir da frase inteira (palavras à *esquerda e à direita*), então cada ocorrência tem seu próprio vetor.

É baseado no *Transformer*:
- *Atenção:* para representar cada palavra, o modelo "olha" todas as outras da frase com pesos diferentes. Em "sacar dinheiro no banco", "banco" presta muita atenção em "sacar" e "dinheiro".
- *Processa todos os tokens em paralelo* (uma RNN lê um por vez) → treina muito mais rápido → permite modelos bem maiores.

== Bi-encoder × Cross-encoder

Duas formas de usar o BERT para dar uma nota a um par (consulta, documento):

#fig("images/bicross.png", w: 100%)[Bi-encoder (SBERT): consulta e documento codificados separadamente. Cross-encoder (BERT): par `[CLS] consulta [SEP] documento [SEP]` → $"score" = f(h_"CLS")$.]

- *Bi-encoder (Sentence-BERT):* gera *um vetor para a consulta* e *um vetor para o documento*, cada um sozinho; $"score" = cos(arrow(q), arrow(d))$.
- *Cross-encoder:* coloca consulta e documento *na mesma entrada* do BERT. A atenção cruza os tokens dos dois, e o modelo devolve o score direto.

A diferença-chave: no bi-encoder, o vetor do documento *não depende da consulta* → dá para calcular todos *antes*, uma vez só.

#table(
  columns: (auto, 1fr, 1fr),
  [], [Bi-encoder (SBERT)], [Cross-encoder (BERT)],
  [Como codifica], [separado; compara vetores], [junto; tokens interagem],
  [Custo na consulta], [docs pré-computados num *índice vetorial*: só codifica a consulta e busca vizinhos → rápido], [roda o BERT *uma vez por documento*: 1 mi docs = 1 mi execuções],
  [Precisão], [perde detalhes finos e termos específicos], [mais preciso],
  [Uso ideal], [*recuperação inicial*], [*reranking*],
)

*Pipeline comum:* o rápido filtra e o preciso ordena poucos.
#flow[Bi-encoder: top 100–1000 de milhões][Cross-encoder: reranking desses poucos][ranking final]

== Lexical × semântica: quando usar

- *Lexical (BM25):* quando o termo *exato* importa e embeddings tendem a "aproximar" errado: `ERR_CONNECTION_RESET`, CID-10 E11.9, RTX 5090, nomes próprios, termos raros.
- *Semântica (embeddings):* quando o usuário descreve com *outras palavras*: "minha conexão cai toda hora", "carro que consome pouca gasolina", paráfrases.

Na prática, muitos sistemas combinam os dois (busca *híbrida*).

#table(
  columns: 4,
  [Modelo], [Representação], [Contextual?], [Gera vetor de],
  [BoW], [esparsa], [não], [documento],
  [TF-IDF], [esparsa], [não], [documento],
  [Word2Vec], [densa], [não], [palavra (fixo)],
  [BERT], [densa], [sim], [cada token na frase],
  [Sentence-BERT], [densa], [sim], [sentença/documento],
)

= Representação, Consultas e Inferência Semântica (Aula 10)

*Ideia central:* embeddings sabem que coisas são *parecidas*, mas não sabem *como* se relacionam. Para isso, o conhecimento precisa estar escrito explicitamente.

#table(
  columns: (1fr, 1fr),
  [Semântica *implícita* (embeddings)], [Semântica *explícita* (grafos de conhecimento)],
  [significado espalhado nos números de um vetor], [entidades e relações *com nome*],
  ["carro" está *perto* de "automóvel"], ["Ana *orienta* Carlos"],
  [boa para texto livre e paráfrases], [boa para consultas precisas; *permite inferência*],
  [difícil explicar por que dois itens são similares], [interpretável: dá para mostrar o caminho],
)

*Limites dos embeddings:*
- A relação existe, mas fica escondida: o vetor não diz *qual* é a ligação entre dois itens.
- Consultas com *várias restrições encadeadas* exigem estrutura: "quem orientou o aluno que publicou o artigo X?" = artigo → autor → orientador. Nenhuma similaridade de vetores segue esse caminho.

*Tipo de resposta:* 

- Busca textual/vetorial devolve *documentos ranqueados*
- Consulta estruturada devolve *entidades que satisfazem um padrão*. 

Nenhuma é universalmente melhor.

== Blocos do conhecimento explícito

- *Entidade:* algo identificável (pessoa, lugar, instituição...). Nomes diferentes podem ser a *mesma* entidade: USP = Universidade de São Paulo = University of São Paulo.
- *Relação:* ligação *com nome* entre entidades (`autorDe`, `orienta`, `localizadoEm`). É o que torna o conhecimento *navegável*: dá para ir de uma entidade à outra.

#Highlight2("RDF")[
  Padrão da Web para escrever fatos como *triplas (sujeito, predicado, objeto)*, lidas como uma frase: (ArtigoX, temAutor, Carlos) = "o Artigo X tem como autor Carlos".

  - Juntando as triplas, forma-se um *grafo*: nós = entidades, arestas = relações.
  - Cada entidade tem um *URI* (`http://exemplo.org/pessoa/Ana`), um "RG" único que evita ambiguidade entre duas "Ana".
  - *Vocabulários* padronizam os nomes das classes e propriedades (ex.: `rdf:type` = "é um(a)").

  Ex.: "Ana é professora da USP. Ana orienta Carlos. Carlos é autor do Artigo X." →
  (Ana, rdf:type, Professor) · (Ana, afiliadoA, USP) · (Ana, orienta, Carlos) · (Carlos, autorDe, ArtigoX).
]

*Ontologia:* o "esquema" do domínio. Define *que tipos de coisas existem e como podem se relacionar*, sem falar de ninguém em particular.
- *Classe:* um tipo (Professor). *Instância:* um caso concreto (Ana). *Propriedade:* uma relação ou atributo (orienta, `rdf:type`).
- *Hierarquias:* Professor ⊂ Pesquisador ⊂ Pessoa → todo professor é pessoa.
- Separa o *conhecimento geral* ("professores orientam alunos") dos *fatos* ("Ana orienta Carlos").

*Grafo de conhecimento* = ontologia (o esquema) + entidades e relações concretas (os dados). Apoia busca, recomendação, explicação e RAG.

#dica[Grafo: Ana pesquisa RI · Ana afiliadoA ICMC · ICMC parteDe USP · Artigo1 temAutor Ana.

  "Quais artigos *sobre RI* foram publicados por pesquisadores da USP?" → *não dá para responder*: o grafo diz que *Ana* pesquisa RI, mas não diz o *tema do Artigo1*. O grafo só responde com o que está nele (ou com o que pode ser *inferido*, veja abaixo).]

== SPARQL: consultando o grafo

Você escreve *triplas com lacunas* (variáveis `?x`), e o sistema procura no grafo valores que preencham *todas* as lacunas ao mesmo tempo (cada padrão é uma restrição, e o resultado é a interseção).

```sparql
SELECT ?professor WHERE {
  ?professor :pesquisa  :RI .
  ?professor :afiliadoA :USP .
}
```
Lê-se: "ache todo `?professor` que pesquisa RI *e* é afiliado à USP".

Atenção: no grafo da dica, Ana é afiliada ao *ICMC*, não diretamente à USP → essa consulta *não* a encontra sem inferência.

*Exemplos no Wikidata* (entidades e propriedades são códigos: `wd:Q…` = entidade, `wdt:P…` = propriedade):
- `?cidade wdt:P131 wd:Q175` → itens localizados no estado de SP.
- `?filme wdt:P31 wd:Q11424; wdt:P136 wd:Q157443; wdt:P161 wd:Q47100` → é um filme; gênero comédia; elenco inclui Ben Stiller. O `;` repete o mesmo sujeito.
- `SERVICE wikibase:label { bd:serviceParam wikibase:language "pt". }` → troca os códigos por nomes legíveis em português.

== Inferência: deduzir o que não está escrito

*Fatos + regras ⇒ novos fatos.* Permite responder mesmo quando o fato não foi armazenado.

- *Hierarquia de classes:* `:Ana rdf:type :Professor` + `:Professor rdfs:subClassOf :Pessoa` ⇒ `:Ana rdf:type :Pessoa`.
- *Propriedade transitiva:* se `parteDe` é transitiva: ICMC parteDe USP + USP parteDe SistemaEstadual ⇒ ICMC parteDe SistemaEstadual.
- *Encadeamento de propriedades:* regra "se X parteDe Y e Y localizadoEm Z, então X localizadoEm Z": ICMC parteDe USP + USP localizadoEm São Paulo ⇒ ICMC localizadoEm São Paulo.
- *Regras do domínio:* "se X afiliadoA Y e Y parteDe Z, então X afiliadoA Z" ⇒ Ana afiliadoA USP. Agora a consulta SPARQL acima *encontra* Ana.

Tudo isso depende do *significado declarado* das propriedades: o sistema só deduz o que as regras e a ontologia autorizam.

*KGs conhecidos:* Wikidata, DBpedia (extraído da Wikipedia), UMLS/MeSH/SNOMED CT (biomédico), Gene Ontology, ChEBI (química), GeoNames (geografia), CIDOC CRM (patrimônio cultural), BIBFRAME (bibliográfico), OpenAlex (científico), schema.org (produtos/organizações na Web).

*Desafios:*
- Exige *modelar* o domínio (trabalhoso).
- Reconhecer e desambiguar entidades no texto é difícil (que "Ana"? "USP" é a mesma que "Universidade de São Paulo"?).
- O grafo é *incompleto/desatualizado*: o que não está lá não é respondido.
- Regras mal definidas → inferências *erradas*.
- Nem toda necessidade cabe numa consulta estruturada.

#dica[Qual abordagem?
  - "RTX 5090 benchmark CUDA 13" → *textual* (termos exatos, códigos).
  - "reduzir consumo de energia em edifícios" → *vetorial* (conceito, muitas formas de dizer).
  - "artigos de professores da USP que trabalham com RI" → *estruturada* (restrições encadeadas), ou combinação.
  - "hipertensão sem usar 'pressão alta'" → *vetorial*. Mesmo que o documento não use o termo "hipertensão", o embedding aproxima os sinônimos.
]

= Busca Híbrida, Reranking e RAG (Aula 11)

*Ideia central:* um bom sistema de busca não é um modelo só, mas uma *sequência de etapas*, cada uma mais cara e mais precisa que a anterior.
#flow[Encontrar candidatos][Combinar evidências][Reordenar os melhores][Gerar resposta]
RAG é uma *arquitetura composta* que encadeia essas etapas, e não apenas um "modelo de busca".

== Busca esparsa × densa × híbrida

- *Esparsa (lexical):* um peso por *termo do vocabulário*, quase todos zero ($[0, 0, 3.1, 0, 1.7, ...]$); usa índice invertido. Forte quando a *palavra exata* importa ("erro 404 nginx"). Ex.: modelo vetorial TF-IDF, BIM, BM25.
- *Densa (semântica):* embeddings ($[0.21, -0.43, 0.72, ...]$), todas as posições preenchidas; busca os *vizinhos mais próximos* por $cos(arrow(q), arrow(d))$. Forte em *paráfrases* ("pressão alta" ↔ "hipertensão arterial").
- *Híbrida:* cada uma erra onde a outra acerta. Nenhum ranking isolado captura todas as evidências → *combinar* os dois.

#Highlight1("Fusão de rankings")[
  *Por score:* média ponderada das notas:
  $ "score"(d) = alpha "score"_"lex"(d) + (1 - alpha) "score"_"sem"(d) $
  Problema: as escalas são diferentes (BM25 pode dar 12,7; cosseno fica entre −1 e 1). Sem *normalizar* antes (ex.: min-max para [0, 1]), um dos lados domina.

  *Por posição — Reciprocal Rank Fusion (RRF):* ignora os scores e usa só a *posição* em cada ranking:
  $ "RRF"(d) = sum_(r in R) 1/(k + "rank"_r (d)) $
  - Quem aparece *bem colocado em vários rankings* acumula pontos e sobe.
  - $k$ suaviza a diferença entre as posições (usual $k = 60$): com $k$ grande, ser 1º ou 5º muda pouco; com $k$ pequeno, o topo domina.
  - Não precisa normalizar escalas → simples e robusto.
]

#example[Lexical: D3, D7, D2 · Semântico: D5, D3, D8 ($k=60$).

- $"RRF"(D_3) = 1\/61 + 1\/62 = 0.0325$ (aparece nos dois); 
- $"RRF"(D_5) = 1\/61 = 0.0164$; 
- $"RRF"(D_7) = 1\/62 = 0.0161$; 
- $"RRF"(D_2) = "RRF"(D_8) = 1\/63 = 0.0159$.

Final: *D3, D5, D7, D2/D8*. D3 não foi 1º em nenhum ranking, mas ganha por aparecer nos dois.]

*Resultados em estágios:* rodar o modelo mais preciso em milhões de documentos é caro demais. Então:
- *1ª etapa, barata:* trazer quase tudo que pode ser relevante → foco em *revocação*.
- *2ª etapa, cara:* ordenar bem esses poucos candidatos → foco em *precisão*.
#flow[1.000.000 docs][recuperação rápida][top-100][reranker preciso][top-10]

== Reranking

Reordena os candidatos *já recuperados* (top-K) usando sinais mais caros. *Não substitui* a recuperação inicial: só reordena o que recebeu.

#table(
  columns: 4,
  [Tipo], [Qualidade], [Custo], [Quando usar],
  [*Heurístico/regras:* recência, autoridade, diversidade; pesos definidos à mão], [limitada], [muito baixo], [regras de negócio simples],
  [*Learning to Rank:* RankSVM, LambdaMART; features como BM25, TF-IDF, PageRank, cliques], [alta], [baixo a médio], [há bons atributos + dados de relevância],
  [*Neural:* cross-encoder, monoBERT, monoT5], [alta a muito alta], [médio a alto], [busca semântica, RAG],
  [*Baseado em LLM:* gera scores, compara pares ou ordena listas], [potencialmente muito alta], [alto a muito alto], [consultas complexas, que exigem raciocínio],
)

*Como os tipos se diferenciam*, a partir de uma mesma fórmula:
$ "score"(d) = w_1 "BM25"(d,q) + w_2 "PageRank"(d) + w_3 "recency"(d) $

OBS: PageRank = importância/autoridade da página com base nos links de outras páginas que apontam para ela. Recency = O quanto o documento é recente.

- pesos $w_i$ escolhidos *à mão* → heurístico;
- pesos *aprendidos* com dados de relevância → LTR (as features podem precisar de normalização);
- o modelo lê o *texto* e aprende sozinho o que importa (sem features prontas) → neural;
- o critério é uma *instrução em linguagem natural* ("ordene pela utilidade para…") → LLM.

*Trade-off:* recuperação inicial = rápida e escalável; reranking = preciso, mas caro, então só em poucos itens; geração = só é tão boa quanto o que foi recuperado.

== RAG (Retrieval-Augmented Generation)

#fig("images/rag.png", w: 100%)[Arquitetura básica de RAG: offline (chunking → embeddings → índice vetorial) e online (consulta → recuperação top-k → seleção de contexto → prompt → LLM → resposta).]

*Por quê?* Uma LLM sozinha só sabe o que está nos *parâmetros*: o conhecimento fica desatualizado, ela não conhece documentos internos e alucina. Com RAG, a LLM responde *a partir de documentos buscados na hora*: atualizada, adaptada ao domínio e capaz de *citar fontes* (desde que a origem de cada trecho seja preservada).

*Fase offline (preparar a base):*
- *Chunking:* quebrar os documentos em pedaços.
  - Chunks *pequenos* → busca mais precisa, mas cada um tem pouco contexto.
  - Chunks *grandes* → mais contexto, mas trazem ruído junto.
  - *Overlap:* repetir um pouco do texto entre chunks vizinhos, para uma ideia não ser cortada ao meio.
  - *Metadados* em cada chunk: fonte, seção, página, autor, data (para filtrar e citar).
- *Indexação:* RAG denso = embedding de cada chunk num índice vetorial; RAG híbrido = índice vetorial + índice lexical (+ metadados).

*Fase online (responder):* recuperar → *selecionar contexto* → montar prompt → LLM.

*Seleção de contexto:* nem todo chunk recuperado deve ir ao prompt. A janela é limitada, e *contexto ruim → resposta ruim*.

#table(
  columns: (auto, 1fr, auto),
  [Técnica], [Como funciona], [Objetivo],
  [Top-K], [fica com os K chunks de maior score], [limitar quantidade],
  [Threshold], [descarta chunks abaixo de um score mínimo], [tirar pouco relevantes],
  [Reranking], [reavalia os candidatos com cross-encoder], [melhorar relevância],
  [MMR], [escolhe um chunk por vez: relevante para a consulta *e* diferente dos já escolhidos], [reduzir redundância],
  [Deduplicação], [remove chunks iguais/quase iguais], [evitar repetição],
  [Filtro por metadados], [data, fonte, permissões do usuário...], [adequação],
  [Contextual compression], [extrai só a parte do chunk que responde à pergunta], [gastar menos tokens],
  [Seleção por cobertura], [garante chunks para *cada aspecto* da pergunta], [evitar resposta incompleta],
)

*Prompt RAG* = instruções ("responda usando *apenas* o contexto; se não houver evidência, diga que não encontrou") + chunks recuperados + pergunta.

*Onde dá errado:*
- *Na recuperação:* o chunk certo não veio (baixa revocação); veio, mas incompleto; veio misturado com ruído que compete com ele; chunks repetidos ocupam a janela.
- *Na geração (alucinação):* responde além do que o contexto diz, combina trechos de forma errada, ignora contradições, inventa. Um bom sistema precisa saber dizer *"não encontrado"*.

#dica[Pipeline: BM25 + densa → RRF → top-20 → cross-encoder → top-5 → RAG. O doc relevante estava em *35º no BM25* e *4º na densa*, mas ficou em *22º após a fusão* e nunca chegou ao reranker.

*Por quê?* $"RRF" = 1\/95 + 1\/64 approx 0.026$. Docs medianos nos *dois* rankings (ex.: 10º e 10º: $2\/70 approx 0.029$) passam na frente dele.

*Conclusão correta:* aumentar o nº de candidatos enviados ao reranker *pode* recuperá-lo, mas aumenta custo/latência e não dá garantia.

*Armadilhas:* o reranker não enxerga o que não recebe; o RRF não "preserva" o 4º lugar de um ranking; a culpa não é da LLM, porque o doc nunca chegou a ela.]

== Avaliação de RAG

Avaliar *cada etapa separadamente*, para saber onde está o problema:
- *Recuperação* (sem olhar a resposta): os chunks certos vieram? Recall\@K, Precision\@K, MRR, nDCG, *cobertura* dos aspectos da pergunta.
- *Resposta:* *correção* (está certa?), *fidelidade* (está apoiada no contexto, ou foi inventada?), *completude*, utilidade, *rastreabilidade* (dá para ver de onde veio cada afirmação?). Uma resposta *fluente* não é necessariamente *correta*.
- *Ponta a ponta:* localizar em qual etapa falhou: #flow[Recuperação][Reranking][Contexto][Geração]

*GraphRAG:* RAG que também usa um *grafo de conhecimento*. Extrai entidades e relações dos docs → constrói o grafo → indexa docs e nós → recupera *trechos + subgrafos*. Ajuda em perguntas que exigem *conectar informações* espalhadas em vários documentos.

*Sistemas integrados:* busca lexical + vetorial + estruturada (SPARQL) → seleção de contexto → LLM.

*O que RAG não resolve:* não garante recuperar o doc certo nem contexto suficiente; não elimina alucinações; não dispensa avaliação nem curadoria da base; não resolve documentos que se contradizem.

= Busca na Web (Aula 12)

*Por que a Web é difícil?*
- *Dados:* distribuídos, voláteis (mudam/somem), enorme volume, não estruturados, redundantes, qualidade variável, heterogêneos, multimídia.
- *Usuários:* dificuldade de formular e interpretar consultas, personalização, interações, interface; esperam resposta *rápida e relevante*.

*Números (históricos):*
- > 778 mi computadores (2010); > 285 mi servidores Web (2011) ≈ 1 servidor a cada 3 computadores.
- > 20 bi páginas estáticas (2005), dobrando a cada 8 meses; páginas *dinâmicas* (geradas sob demanda) são potencialmente infinitas.
- Formatos: HTML, GIF/JPEG, ASCII, PDF. A maioria das páginas *não segue o padrão HTML* à risca, e as páginas são pequenas.
- Links: a maioria das páginas não recebe *nenhum* link de outro site (nº médio ≈ 0; os links são quase todos internos). Diretórios e a Web 2.0 ajudam a evitar "ilhas" isoladas.
- Idioma: em 2000, ~70% em inglês, mas outras línguas crescem mais rápido.

== Grafo da Web (gravata-borboleta)

#grid(
  columns: (45%, 1fr),
  gutter: 12pt,
  image("images/bowtie.png", width: 100%),
  [
    Nós = páginas; arestas = links. O formato lembra uma gravata-borboleta:
    - *CORE (SCC):* o centro. De qualquer página dele se chega a qualquer outra.
    - *IN:* chega ao CORE, mas não volta (ex.: páginas novas que ninguém linka ainda).
    - *OUT:* alcançável a partir do CORE, mas sem caminho de volta (ex.: sites corporativos que só têm links internos).
    - *TUBES:* caminhos de IN para OUT sem passar pelo CORE.
    - *TENTACLES:* saem de IN ou chegam a OUT sem tocar no CORE.
    - *Desconectados:* sem ligação com o resto.

    *CORE por dentro:* *pontes* (alcançáveis de IN *e* alcançam OUT), *pontos de entrada* (só alcançáveis de IN), *pontos de saída* (só alcançam OUT) e *normais*.

    O núcleo tem a *minoria dos sites*, mas são os sites com *mais páginas*.
  ],
)

== Arquitetura de máquinas de busca

- A consulta é respondida *sem acessar as páginas originais*: tudo vem de *cópias locais* coletadas antes. Os snippets também saem dessas cópias e são gerados só para o top-N.
- *Centralizada coletor-indexador* (AltaVista): crawlers → repositório central → índice invertido.
  - Calcula só os $N$ primeiros resultados (geralmente 10). Se o usuário pede a próxima página, *recalcula* ou usa um conjunto parcial guardado em memória. *Nunca* computa a resposta completa.
  - Não escalou com o crescimento da Web no fim dos anos 90.
- *Baseada em clusters* (solução moderna):
  - Índice *particionado por documentos*: cada máquina indexa uma parte da coleção, e a consulta vai a todas.
  - *Replicação:* o mesmo índice em vários clusters, inclusive em países diferentes (menor latência e mais capacidade).
  - Desafios: balancear coleta × indexação/consultas e a carga entre clusters.
  - *Tolerância a falhas por software:* hardware barato quebra o tempo todo e é trocado rotineiramente; o software redireciona a consulta para um cluster saudável.
  - Melhorias: cache de resultados, múltiplos índices, arquiteturas distribuídas (Harvest, Multisite).

== Ranqueamento na Web

A função mais difícil *e* mais importante. *4 desafios:*

+ Avaliar se o ranking está bom
+ Identificar páginas de qualidade
+ Resistir a *spam* (páginas manipuladas para subir)
+ Definir e calcular a função em escala.

*Sinais usados:*
- *Conteúdo:* frequência das palavras; *layout* (termo no título/cabeçalho pesa mais); proximidade entre termos e tags.
- *Estrutura (links):* nº de links de entrada/saída; *texto-âncora*, o texto clicável que aponta para a página, usado como "descrição" dela escrita por outros.
- *Uso:* cliques (feedback implícito), localização, SO/navegador, histórico (cookies).

#Highlight1("PageRank")[
  *Intuição:* uma página é importante se *páginas importantes* apontam para ela. Imagine um usuário navegando ao acaso (*random surfer*):
  - com probabilidade $d$, clica num link aleatório da página atual;
  - com probabilidade $1 - d$, se cansa e salta para uma página qualquer.

  O PageRank mede o quanto ele visita cada página a longo prazo.
  $ "PR"(a) = (1 - d) + d sum_(i=1)^n ("PR"(p_i))/(L(p_i)) $
  - $p_1..p_n$ = páginas que *apontam para* $a$;
  - $L(p)$ = nº de links de *saída* de $p$: cada página *divide* seu PR igualmente entre os links que faz;
  - $d$ = fator de amortecimento (ex.: 0.85).

  *Páginas sem links de saída* "prendem" o surfer. Soluções: usar $d = 0$ nelas, ou removê-las, calcular o resto e depois calcular o PR delas a partir das páginas que apontam para elas.

  *Cálculo iterativo:* o PR de A depende do de B, que depende do de A (ciclos). Então começa-se com um chute e repete-se a fórmula até os valores estabilizarem.
]

#grid(
  columns: (35%, 1fr),
  gutter: 12pt,
  align(center + horizon, cetz.canvas(length: 1cm, {
    import cetz.draw: *
    let node(p, n) = {
      circle(p, radius: 0.35, fill: colors.primary.lighten(85%), stroke: colors.primary, name: n)
      content(p, n)
    }
    node((0, 0), "A")
    node((2, 0), "B")
    node((1, -1.6), "C")
    line((0.35, 0.12), (1.65, 0.12), mark: (end: ">", fill: black))
    line((1.65, -0.12), (0.35, -0.12), mark: (end: ">", fill: black))
    line("B", "C", mark: (end: ">", fill: black))
    line("C", "A", mark: (end: ">", fill: black))
  })),
  [
    #set text(size: 0.9em)
    - A→B, B→A, B→C, C→A. 
    - Saídas: $L(A) = 1$, $L(B) = 2$, $L(C) = 1$. 
    - Início: PR = 0, $d = 0.85$.

    Quem aponta para quem: A ← B, C · B ← A · C ← B.

    Os valores *já atualizados na mesma iteração* são reaproveitados (A, depois B, depois C).

    *1ª iter.:* 
    
    - $"PR"(A) = 0.15 + 0.85(0\/2 + 0\/1) = 0.15$
    - $"PR"(B) = 0.15 + 0.85(0.15\/1) = 0.2775$
    - $"PR"(C) = 0.15 + 0.85(0.2775\/2) = 0.2679$.

    *2ª iter.:* 
    
    - $"PR"(A) = 0.15 + 0.85(0.2775\/2 + 0.2679\/1) = 0.4956$
    - $"PR"(B) = 0.15 + 0.85(0.4956) = 0.5712$
    - $"PR"(C) = 0.15 + 0.85(0.5712\/2) = 0.3927$.
  ],
)

*Funções de ranqueamento:*
- *Simples:* ordenar só pelo PageRank. É *global*, calculado uma vez e independente da consulta; a consulta só *seleciona* quais páginas entram.
- *Sofisticada:* combinar relevância textual e importância:
$ R(p, q) = alpha F(p, q) + (1 - alpha) "PR"(p) $
$F$ = ranking textual (ex.: BM25); $alpha$ ajustado com dados rotulados ou cliques. Pode variar por tipo de consulta: em consultas *navegacionais* ("site do Itaú"), o usuário quer *a* página oficial → $alpha$ menor, mais peso aos links.

== Interação com o usuário

- *Interface de simplicidade extrema:* uma caixa de busca (+ busca avançada, plugins). *Ultimate rectangle:* a barra de endereço do Chrome também é a caixa de busca.
- *Sintaxe das consultas:* uma sequência de palavras com *AND implícito*.
  - Unários: `+`, `-` (excluir), `site:`. Binários: `OR`. Delimitadores: aspas (frase exata).
  - Específicos por buscador: Ask (`afterdate:`, `beforedate:`, `betweendate:`, `last:`), Bing (`AND/&`, `()`, `filetype:`, `contains:`, `ip:`, `feed:`, `prefer:`), Google (curinga `*`), Yahoo (`link:`).
- *Sugestões dinâmicas (autocomplete),* ideia que já existia no Emacs e no shell. Precisa de correção ortográfica, filtro de sugestões inapropriadas, remoção de duplicadas, diversidade, novidade e personalização.
- *Resultados estruturados:* a resposta vai além de "10 links azuis":
  - Google Onebox: resposta direta ("who is the governor of california");
  - Universal search: mistura imagens, vídeos e mapas;
  - Ask: respostas de Q&A, sem snippet;
  - Bing/Google: "de São Paulo para Belém" → rota.
- *Did You Mean* (Google): em vez de dicionário + edit distance, usa os *logs*. Se muita gente busca "britney spears" e pouca busca "britinei spers", a grafia mais frequente é sugerida ("sabedoria das massas"). Sem logs grandes, usam-se outros sinais, como o usuário *reformular a consulta logo em seguida*.
- *Temas de pesquisa:* layout da página de resultados, snippets gerados em tempo de execução, Q&A, personalização, recomendação e refinamento interativo de consultas.