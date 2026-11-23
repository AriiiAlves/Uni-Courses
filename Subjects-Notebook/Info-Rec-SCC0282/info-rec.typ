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

// Caixa de "pegadinha de prova"
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
  - Mapeia termo → *termID* (dicionário global em memória).
  - Divide a coleção em blocos iguais; par (termID, docID) = 8 bytes → bloco de 10 MB ≈ 1,25 mi pares.
  - Ordena os pares *de cada bloco em memória*, grava índice parcial em disco.
  - *Merge:* abre todos os blocos, pega sempre o menor termo ainda não processado, junta as listas e grava.
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
  - Usa *termos* direto (sem termID / mapeamento global); dicionário *por bloco*, criado dinamicamente.
  - Cada posting list cresce *dinamicamente* conforme os tokens chegam — sem coletar e ordenar todos os pares.
  - Ao encher a memória, ordena *só o dicionário*, grava bloco (tamanho variável) e começa outro.
  - Vantagens: mais rápido (não ordena registros), economiza memória, blocos maiores → menos acessos a disco.
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

== Indexação distribuída (MapReduce)

Máquina *mestre* divide o trabalho em tarefas paralelas (máquinas falham!). Coleção dividida em *trechos* (≈ blocos do BSBI/SPIMI).
#flow[Mestre atribui trecho][*Parser* (map): emite (termo, doc)][grava em $j$ partições por faixa de letras (a–f, g–p, q–z)][*Inversor* (reduce): coleta 1 partição, ordena, gera postings]
É uma instância do *MapReduce* (Google).

== Atualização e compressão

- *Atualização incremental:* índice *principal* grande e estável + índice *auxiliar* pequeno com novidades; consulta os dois; merge periódico gera nova versão.
- *Inserção* → no auxiliar. *Alteração* = remoção da versão antiga + inserção da nova.
- *Deleção lógica:* marca como deletado (barato); *física:* espaço recuperado depois, no merge/compactação.
- *Compressão:* menos espaço, menos transferência, melhor cache, consultas potencialmente mais rápidas.
  - *Gap encoding:* `[100, 105, 106, 130]` → `[100, 5, 1, 24]` (docIDs crescentes ⇒ gaps pequenos).
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

O dicionário guarda termo, df e ponteiro para a posting. Requisitos: busca exata, por *prefixo* (hyp\*), atualização, busca *aproximada* (retrival → retrieval).

#table(
  columns: 3,
  [Estrutura], [Vantagens], [Desvantagens],
  [Hashtable], [lookup $O(1)$], [variantes (judgment/judgement), *sem prefixo*, crescer exige *rehashing*],
  [Array ordenado (char[20] + int + ponteiro = 32 B)], [simples, busca binária], [atualização (inserir/remover)],
  [Árvores (binária, B, Trie, Patricia)], [*resolve prefixo*], [mais lento: $O(log M)$ balanceada, $O(L)$ Trie; rebalancear é caro (B-tree faz sozinha)],
)
*Prefix B-tree:* chaves são o *menor prefixo que distingue* as chaves do nível abaixo (não precisa ser prefixo do termo); nós com nº variável de chaves; folhas guardam termos + dados.

== Correção ortográfica

Usos: normalizar/enriquecer o índice (preservando original) e corrigir consultas. Casos: *palavra isolada* (from → form) e *sensível ao contexto* ("I flew form Sao Paulo").

- *Edit distance (Levenshtein):* mín. de inserções, remoções, substituições. kitten → sitting = *3*. *Weighted*: pesos por caractere (ex.: teclas vizinhas).
- Força bruta: distância contra todo o vocabulário. Heurística: só termos com a mesma 1ª letra. Melhor: *sobreposição de n-gramas*.
- Bigramas de "teacher": `$t, te, ea, ac, ch, he, er, r$`. Índice de n-gramas: bigrama → termos que o contêm (lo → alone, lore, sloth).

#Highlight1("Coeficiente de Jaccard")[
  $ J(X, Y) = (|X inter Y|)/(|X union Y|) $
  lord {lo, or, rd} × ordinary {or, rd, di, in, na, ar, ry}: $2\/8 = 0.25$. lord × lore {lo, or, re}: $2\/4 = 0.5$.
]

*Algoritmo:* (1) enumerar n-gramas da consulta e dicionário; (2) recuperar termos via índice de n-gramas; (3) manter os com nº de casamentos ≥ *limiar 1*; (4) Jaccard ≥ *limiar 2*; (5) edit distance nos sobreviventes.

#example[$q$ = retrival (bigramas: re, et, tr, ri, iv, va, al), limiar 1 = 4, limiar 2 = 0,44.

Casamentos: retrieval 6, revival 4, trivial 4, arrival 4, retrieve 4, retinal 3 (cai).

Jaccard: retrieval $6\/9 = 0.667$; revival, trivial, arrival $4\/9 = 0.444$ (passam); retrieve $4\/10 = 0.40$ (cai).

Edit distance: retrieval *1*, revival 2, trivial 3, arrival 3 → *"Você quis dizer: retrieval?"*]

*Sensível ao contexto:* gerar variantes corrigindo um termo por vez (flew from / fled form / flea form...) e sugerir a que tem *mais resultados*. Otimização: usar *biwords* mais frequentes na coleção ou nos *logs de consultas* ("flew from" é mais comum).

= Recuperação Semântica e Modelos de Linguagem (Aula 09)

Modelos lexicais (BM25) *não estão obsoletos*; a semântica tenta aproximar pelo *significado*. Problema central: "carro barato" × "veículo de baixo custo".

- *Vocabulary mismatch:* dor de cabeça/cefaleia, notebook/computador portátil, demissão/desligamento.
- *Sinonímia:* palavras diferentes, mesmo conceito → lexical *perde relevantes* → *falsos negativos*, ↓ *revocação*.
- *Polissemia:* mesma palavra, vários sentidos (banco) → *falsos positivos*, ↓ *precisão*.
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

#Highlight2("Query Likelihood Model")[
  Ranqueia pela chance de o doc "gerar" a consulta:
  $ P(q|d) = product_(i=1)^m P(q_i | d), quad log P(q|d) = sum_i log P(q_i|d) $
  *Suavização* (evita zeros), mistura doc + coleção:
  $ P(w|d) = (1 - lambda) P(w|d) + lambda P(w|C) $
]
Ex.: "banco de dados"; $d_1$ "Curso de banco de dados relacional" → $P(q|d_1) = 1\/6 dot 2\/6 dot 1\/6 approx 0.00926$; $d_2$ "O banco oferece dados de investimentos" → $approx 0.00463$. Com bigramas, $d_2$ zera ($P("de"|"banco") = 0$).

Limitação dos clássicos (QLM, vetorial): só evidência lexical; sem sinônimos, paráfrases ou contexto.

== Embeddings

*Representação distribuída:* palavra → vetor denso (carro → [0.21, −0.43, 0.72, ...]); palavras relacionadas ficam próximas. *Hipótese distribucional:* "You shall know a word by the company it keeps".

*Word2Vec:* *CBOW* (contexto → palavra) e *Skip-gram* (palavra → contexto; aprende $P(k_i|k_j)$ com pares de uma janela). Propriedades: similaridade por cosseno e relações por aritmética: $"king" - "man" + "woman" approx "queen"$; $"Paris" - "France" + "Italy" approx "Rome"$. *Limitação:* *um vetor estático por palavra* ("banco" igual em "sacar dinheiro" e "praça").

*BERT:* Transformer, embeddings *contextuais* (contexto à esquerda e à direita). *Transformer:* mecanismo de *atenção* (cada palavra "olha" as outras com pesos); processa tokens *em paralelo* (≠ RNN) → modelos maiores.

== Cross-encoder × Bi-encoder

#fig("images/bicross.png", w: 100%)[Bi-encoder (SBERT): consulta e documento codificados separadamente. Cross-encoder (BERT): par `[CLS] consulta [SEP] documento [SEP]` → $"score" = f(h_"CLS")$.]

#table(
  columns: (1fr, 1fr),
  [Bi-encoder (Sentence-BERT)], [Cross-encoder (BERT)],
  [codifica separadamente; $"score" = cos(arrow(q), arrow(d))$], [consulta + doc juntos; interação direta entre tokens],
  [docs *pré-computados* → índice vetorial, rápido, escalável], [1 milhão de docs = rodar BERT 1 milhão de vezes],
  [ótimo para *recuperação inicial*], [ótimo para *reranking* (mais preciso)],
  [perde detalhes finos; nem sempre captura termos específicos], [caro; não pré-computa],
)
Pipeline comum: #flow[Bi-encoder (top 100–1000)][Cross-encoder (reranking)][ranking final]

*Quando usar:* lexical para `ERR_CONNECTION_RESET`, CID-10 E11.9, RTX 5090, nomes próprios, termos raros; semântica para "minha conexão cai toda hora", "carro que consome pouca gasolina", paráfrases.

#table(
  columns: 4,
  [Modelo], [Representação], [Contextual?], [Unidade],
  [BoW], [esparsa], [não], [documento],
  [TF-IDF], [esparsa], [não], [documento],
  [Word2Vec], [densa], [não], [palavra],
  [Sentence-BERT], [densa], [sim], [sentença/documento],
)

= Representação, Consultas e Inferência Semântica (Aula 10)

#table(
  columns: (1fr, 1fr),
  [Semântica *implícita*], [Semântica *explícita*],
  [embeddings; significado distribuído em vetores], [entidades, relações e regras (grafos de conhecimento)],
  [proximidade = relação semântica], [entidades/propriedades nomeadas],
  [boa p/ textos e paráfrases; menos interpretável], [boa p/ consultas precisas; *permite inferência*],
)
Limites dos embeddings: relações explícitas ficam escondidas; difícil explicar a similaridade; consultas com restrições ("quem orientou o aluno que publicou o artigo X?" = artigo → autor → orientador) exigem *estrutura*. Busca textual devolve docs ranqueados; consulta estruturada devolve *entidades que satisfazem um padrão*. Nenhuma é universalmente melhor.

- *Entidade:* objeto/conceito identificável (pessoa, lugar, instituição...). Nomes diferentes podem ser a mesma entidade (USP = Universidade de São Paulo = University of São Paulo).
- *Relação:* conexão nomeada (`autor_de`, `orientador_de`, `localizado_em`); torna o conhecimento navegável.

#Highlight2("RDF")[
  Padrão da Web: fatos como *triplas (sujeito, predicado, objeto)*, ex. (Artigo X, temAutor, Aluno A). Conjunto de triplas = *grafo* (nós = entidades, arestas = relações). Identificadores *URIs* (`http://exemplo.org/pessoa/Ana`) evitam ambiguidade; *vocabulários* padronizam classes/propriedades.

  Ex.: "Ana é professora da USP. Ana orienta Carlos. Carlos é autor do Artigo X." → (Ana, rdf:type, Professor), (Ana, afiliadaA, USP), (Ana, orienta, Carlos), (Carlos, autorDe, ArtigoX).
]

*Ontologia:* modelo conceitual do domínio — *classes, propriedades, relações e restrições*. Elementos: *classe* (Professor), *instância* (Carolina), *propriedade* (orienta, `rdf:type`). Separa conhecimento geral dos fatos. Permite *hierarquias* (Professor ⊂ Pesquisador ⊂ Pessoa). *Grafo de conhecimento* = ontologia + entidades concretas e relações; apoia busca, recomendação, explicação e RAG.

#dica[Grafo: Ana pesquisa RI; Ana afiliadaA ICMC; ICMC parteDe USP; Artigo1 temAutor Ana. *Não* dá para responder "quais artigos *sobre RI* foram publicados por pesquisadores da USP?" — o grafo não diz o tema do Artigo1.]

== SPARQL e inferência

Linguagem de consulta para RDF: descreve *padrões de triplas*; variáveis (`?x`) indicam o que se quer; resultado = o que satisfaz *todos* os padrões (interseção).
```sparql
SELECT ?professor WHERE {
  ?professor :pesquisa :RI .
  ?professor :afiliadoA :USP .
}
```
Wikidata: `?cidade wdt:P131 wd:Q175` (cidades em SP); `?filme wdt:P31 wd:Q11424; wdt:P136 wd:Q157443; wdt:P161 wd:Q47100` (filme, comédia, Ben Stiller); `SERVICE wikibase:label { bd:serviceParam wikibase:language "pt". }`.

*Inferência:* fatos + regras → novos fatos (responde mesmo sem o fato armazenado).
- *Regras:* autorDe + ... ⇒ relacionadaA (cria relação não armazenada).
- *Transitiva:* ICMC parteDe USP, USP localizadaEm São Paulo ⇒ ICMC em São Paulo (depende do significado das propriedades).
- *Hierarquia:* `:Ana rdf:type :Professor` + `:Professor rdfs:subClassOf :Pessoa` ⇒ `:Ana rdf:type :Pessoa`.

*KGs conhecidos:* Wikidata, DBpedia (Wikipedia), UMLS/MeSH/SNOMED CT (biomédico), Gene Ontology, ChEBI (química), GeoNames, CIDOC CRM (patrimônio), BIBFRAME (bibliográfico), OpenAlex (científico), schema.org (produtos/organizações).

*Desafios:* exige modelagem; reconhecer/desambiguar entidades é difícil; grafo incompleto/desatualizado; regras mal definidas → inferências erradas; nem toda necessidade cabe numa consulta estruturada.

#dica[Qual abordagem? "RTX 5090 benchmark CUDA 13" → *textual*; "reduzir consumo de energia em edifícios" → *vetorial*; "artigos de professores da USP que trabalham com RI" → *estruturada* (ou combinação); "hipertensão sem usar 'pressão alta'" → *vetorial*.]

= Busca Híbrida, Reranking e RAG (Aula 11)

#flow[Encontrar candidatos][Combinar evidências][Reordenar melhores][Gerar resposta]
RAG é uma *arquitetura composta*, não só um "modelo de busca".

== Busca esparsa × densa × híbrida

- *Esparsa:* termos/pesos, vetores com muitos zeros ($[0, 0, 3.1, 0, 1.7, ...]$), índice invertido; forte quando a correspondência exata importa ("erro 404 nginx"). Ex.: vetorial, BIM, BM25.
- *Densa:* embeddings ($[0.21, -0.43, 0.72, ...]$), vizinhos mais próximos, $cos(arrow(q), arrow(d))$; paráfrases ("pressão alta" ↔ "hipertensão arterial").
- *Híbrida:* nenhum ranking isolado captura todas as evidências → combinar.

#Highlight1("Fusão de rankings")[
  *Por score:* $"score"(d) = alpha "score"_"lex"(d) + (1 - alpha) "score"_"sem"(d)$ — escalas diferentes ⇒ *normalizar*.

  *Por posição — Reciprocal Rank Fusion:*
  $ "RRF"(d) = sum_(r in R) 1/(k + "rank"_r (d)) $
  $k$ controla o quanto o topo domina (usual $k = 60$). Evita comparar escalas; simples e robusto; quem aparece bem em vários rankings sobe.
]

#example[Lexical: D3, D7, D2 · Semântico: D5, D3, D8 ($k=60$).

$"RRF"(D_3) = 1\/61 + 1\/62 = 0.0325$; $D_5 = 1\/61 = 0.0164$; $D_7 = 1\/62 = 0.0161$; $D_2 = D_8 = 1\/63 = 0.0159$.

Final: *D3, D5, D7, D2/D8*.]

*Geração de resultados em estágios:* 1ª etapa barata busca candidatos (*revocação*); 2ª etapa cara refina (*precisão*). #flow[1.000.000 docs][recuperação rápida][top-100][reranker preciso][top-10]

== Reranking

Reordena os candidatos já recuperados (top-K) com sinais mais caros; *não substitui* a recuperação inicial.

#table(
  columns: 4,
  [Tipo], [Qualidade], [Custo], [Quando],
  [Heurístico/regras (recência, autoridade, diversidade; pesos manuais)], [limitada], [muito baixo], [regras de negócio simples],
  [Learning to Rank (RankSVM, LambdaMART; features BM25, TF-IDF, PageRank, cliques)], [alta], [baixo a médio], [bons atributos + dados de relevância],
  [Neural (cross-encoder, monoBERT, monoT5)], [alta a muito alta], [médio a alto], [busca semântica, RAG],
  [LLM-based (scores, par-a-par ou listas)], [potencialmente muito alta], [alto a muito alto], [consultas complexas, raciocínio],
)
Ex.: $"score"(d) = w_1 "BM25"(d,q) + w_2 "PageRank"(d) + w_3 "recency"(d)$ — pesos manuais = heurístico; pesos aprendidos = LTR; aprende do texto = neural; instrução em linguagem natural = LLM. Features podem precisar de normalização.

*Trade-off:* recuperação inicial rápida/escalável; reranking preciso/caro em poucos itens; geração depende da qualidade da recuperação.

== RAG (Retrieval-Augmented Generation)

#fig("images/rag.png", w: 100%)[Arquitetura básica de RAG: offline (chunking → embeddings → índice vetorial) e online (consulta → recuperação top-k → seleção de contexto → prompt → LLM → resposta).]

*Por quê?* LLM sozinha: conhecimento nos parâmetros, desatualizado, alucina. Com RAG: usa documentos externos, *cita fontes* (se a origem dos trechos é preservada), adapta-se ao domínio.

- *Chunking:* chunks pequenos → granularidade; grandes → mais contexto. *Overlap* (repete parte entre chunks) e *metadados* (fonte, seção, página, autor, data).
- *Indexação:* RAG denso (embedding por chunk, índice vetorial); RAG híbrido (+ índice lexical) + metadados.
- *Seleção de contexto:* nem todo chunk recuperado vai ao prompt; filtrar, reordenar, tirar redundância — contexto ruim → resposta ruim.

#table(
  columns: (auto, 1fr, auto),
  [Técnica], [Como funciona], [Objetivo],
  [Top-K], [K chunks de maior score], [limitar quantidade],
  [Threshold], [remove abaixo de um limiar], [tirar pouco relevantes],
  [Reranking], [reavalia com cross-encoder], [melhorar relevância],
  [MMR], [equilibra relevância e *diversidade*], [reduzir redundância],
  [Deduplicação], [remove iguais/similares], [evitar repetição],
  [Filtro por metadados], [data, fonte, permissões...], [adequação],
  [Contextual compression], [extrai só o trecho necessário], [menos tokens],
  [Seleção por cobertura], [chunks p/ aspectos diferentes], [evitar incompletude],
)
*Prompt RAG:* instruções ("responda usando o contexto; se não houver evidência, diga") + contexto recuperado + pergunta.

*Falhas de recuperação:* baixa revocação; chunk certo mas incompleto; ruído competindo; redundância ocupando a janela. *Alucinações:* responder além do contexto, combinar trechos errado, ignorar contradições, inventar — o sistema deve saber dizer *"não encontrado"*.

#dica[Pipeline BM25 + densa → RRF → top-20 → cross-encoder → top-5 → RAG; o doc relevante (35º no BM25, 4º na densa) ficou em 22º após a fusão e nunca chegou ao reranker. Correto: *aumentar o nº de candidatos ao reranker pode melhorar o recall, mas aumenta custo/latência, sem garantia*. O reranker não enxerga o que não recebe; RRF não "obriga" posição 4; a culpa não é da LLM.]

== Avaliação de RAG

- *Recuperação* (independente da resposta): Recall\@K, Precision\@K, MRR, nDCG, *cobertura*.
- *Resposta:* *correção*, *fidelidade* (suportada pelo contexto), *completude*, utilidade, *rastreabilidade*. Fluente ≠ correta.
- *Ponta a ponta:* localizar onde falhou: #flow[Recuperação][Reranking][Contexto][Geração]

*GraphRAG:* além de trechos, explora entidades/relações; extrai entidades e relações → constrói grafo → indexa docs e nós → recupera *trechos + subgrafos*. Ajuda em perguntas que exigem conectar informações. *Sistemas integrados:* busca lexical + vetorial + estruturada (SPARQL) → seleção de contexto → LLM.

*O que RAG não resolve:* não garante recuperar o doc certo nem contexto suficiente; não elimina alucinações; não dispensa avaliação nem curadoria; não resolve conflitos na base.

= Busca na Web (Aula 12)

*Desafios dos dados:* distribuídos, voláteis, volume, não estruturados, redundância, qualidade, heterogeneidade, multimídia. *Dos usuários:* formular/interpretar consultas, personalização, interações, UI, rapidez e relevância.

*Números:* > 778 mi computadores (2010); > 285 mi servidores Web (2011) ≈ 1 servidor a cada 3 computadores; > 20 bi páginas estáticas (2005), tamanho dobra a cada 8 meses; páginas dinâmicas: infinitas. Formatos: HTML, GIF/JPEG, ASCII, PDF. Maioria não segue o padrão HTML; páginas pequenas; nº médio de links externos apontando ≈ 0 (links locais); diretórios e Web 2.0 evitam "ilhas"; em 2000 ~70% em inglês (outras línguas crescem mais rápido).

== Grafo da Web (gravata-borboleta)

#grid(
  columns: (45%, 1fr),
  gutter: 12pt,
  image("images/bowtie.png", width: 100%),
  [
    Nós = páginas; arestas = links. Componentes: *IN* → *CORE (SCC)* → *OUT*, mais *TUBES* (IN→OUT sem passar pelo núcleo), *TENTACLES* e *desconectados*.

    *CORE* se divide em: *Pontes* (alcançáveis de IN e alcançam OUT), *Pontos de entrada* (alcançáveis de IN, não pontes), *Pontos de saída* (alcançam OUT, não pontes) e *Normais*.

    O núcleo tem a *minoria dos sites*, mas *maior densidade de páginas*.
  ],
)

== Arquitetura de máquinas de busca

- Consultas são respondidas *sem acessar as páginas originais* (só cópias locais); snippets usam cópias, apenas para o top-N.
- *Centralizada coletor-indexador* (AltaVista): crawlers → repositório central → índice invertido. Retorna os $N$ primeiros (geralmente 10); para mais, *recomputa* ou usa conjunto parcial em memória; *nunca* computa a resposta completa. Não escalou no fim dos anos 90.
- *Baseada em clusters:* índice *particionado por documentos* entre máquinas; arquitetura *replicada* (inclusive geograficamente, p/ latência); balancear coleta × consultas/indexação e carga entre clusters; tolerância a falhas por software (rotear para o cluster adequado; hardware barato substituído rotineiramente). Melhorias: cache, múltiplos índices, arquiteturas distribuídas (Harvest, Multisite).

== Ranqueamento na Web

Função mais difícil e mais importante. *4 desafios:* (1) avaliação adequada, (2) identificar qualidade, (3) prevenir *spam*, (4) definir/computar a função.

*Sinais:* *conteúdo* (contagem de palavras, layout: mais peso a títulos/cabeçalhos, proximidade de tags) · *estrutura* (links, *texto-âncora* como substituto da página alvo, nº de links de entrada/saída) · *uso* (cliques/feedback implícito, geolocalização, SO/navegador, histórico via cookies).

#Highlight1("PageRank")[
  Usuário que navega aleatoriamente (*random surfer*): segue um link de saída ao acaso; com probabilidade $1 - d$ salta para página aleatória.
  $ "PR"(a) = (1 - d) + d sum_(i=1)^n ("PR"(p_i))/(L(p_i)) $
  $d$ = fator de amortecimento (ex.: 0.85); $L(p)$ = nº de links de saída de $p$; $p_1..p_n$ = páginas que apontam para $a$. Páginas sem saída: usar $d = 0$ nelas ou removê-las e calcular no fim pelo PR dos pais. Cálculo *iterativo* (ciclos impedem cálculo direto).
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
    A→B, B→A, B→C, C→A ($L(B) = 2$). Início: PR = 0.

    *1ª iter.:* $"PR"(A) = 0.15 + 0.85(0\/2 + 0\/1) = 0.15$; $"PR"(B) = 0.15 + 0.85(0.15) = 0.2775$; $"PR"(C) = 0.15 + 0.85(0.2775\/2) = 0.2679$.

    *2ª iter.:* $"PR"(A) = 0.15 + 0.85(0.2775\/2 + 0.2679) = 0.4956$; $"PR"(B) = 0.5712$; $"PR"(C) = 0.3927$.
  ],
)

*Funções de ranqueamento:* simples = global (PageRank), independente da consulta (a consulta só seleciona). Sofisticada = combinação linear:
$ R(p, q) = alpha F(p, q) + (1 - alpha) "PR"(p) $
$F$ = ranking textual; $alpha$ ajustado com dados rotulados ou cliques; pode depender da consulta (consultas *navegacionais* → $alpha$ menor, mais peso aos links).

== Interação com o usuário

- Interface de *simplicidade extrema*: caixa de busca; busca avançada; plugins; *ultimate rectangle* (Chrome: barra de endereço = busca).
- Consultas = sequência de palavras, geralmente com *AND implícito*. Operadores *unários* (`+`, `-`, `site:`), *binários* (`OR`), *delimitadores* (aspas = frase exata). Específicos: Ask (`afterdate:`, `beforedate:`, `betweendate:`, `last:`), Bing (`AND/&`, `()`, `filetype:`, `contains:`, `ip:`, `feed:`, `prefer:`), Google (wildcard `*`), Yahoo (`link:`).
- *Sugestões dinâmicas* (autocomplete — já existia em Emacs/shell): correção ortográfica, filtrar inapropriadas, remover duplicadas, diversidade, novidade, personalização.
- *Resultados estruturados:* Google Onebox (resposta única: "who is the governor of california"), Universal search (imagens, vídeos, mapas), Ask (respostas de Q&A sem snippet), Bing/Google ("de São Paulo para Belém" → rotas).
- *Did You Mean* (Google): em vez de dicionário + edit distance, usa a *frequência da grafia correta nos logs* ("sabedoria das massas": britney spears × britinei spers). Sem logs grandes: outros sinais (usuário reformulando a mesma consulta em seguida).
- Pesquisa: layout da página, snippets em tempo de execução, Q&A, personalização, recomendação e refinamento interativo de consultas.
