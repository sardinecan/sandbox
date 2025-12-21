using CommonMark
using Bibliography
using DocumenterCitations

bibdata = """
@article{smith2020,
  author = {Smith, John},
  title = {Introduction to Julia Programming},
  journal = {Journal of Computing},
  year = {2020},
  volume = {42},
  pages = {123--145}
}

@book{doe2019,
  author = {Doe, Jane},
  title = {Modern Web Development},
  publisher = {Tech Press},
  year = {2019},
  address = {New York}
}
"""

write("bib.bib", bibdata)

bib = import_bibtex("bib.bib")
println("   1. fichier bib chargé avec Bibliography.jl")

article = """
# Mon article

Julia est excellent [@smith2020]. Pour le web, voir [@doe2019].
"""


# Parser le markdown avec CitationRule (Commonmark.jl)
parser = Parser()
enable!(parser, CitationRule())
ast = parser(article)

htmlbody = html(ast)
println("  2. markdown parsé avec CommonMark.jl")

# === 4. FORMATER LA BIBLIOGRAPHIE AVEC DocumenterCitations ===

global bibliographyhtml = """
  <div class="references">
    <h2>Références</h2>
    <ol>
"""

for (key, entry) in bib
    # Formater avec le style :numeric de DocumenterCitations
    formattedmd = DocumenterCitations.format_bibliography_reference(:numeric, entry)

    formattedhtml = replace(formattedmd, r"\*\*([^*]+)\*\*" => s"<strong>\1</strong>")
    formattedhtml = replace(formattedhtml, r"\*([^*]+)\*" => s"<em>\1</em>")

    global bibliographyhtml *= """
      <li id="ref-$key">$formattedhtml</li>
"""

    println("[$key] $formattedmd")
end

bibliographyhtml *= """
    </ol>
  </div>
"""
println("  3. bibliographie formatée avec DocumenterCitations.jl")

fullhtml = """
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="UTF-8">
    <title>CommonMark.jl avec bibliographie</title>
    <style>
        body {
            max-width: 800px;
            margin: 40px auto;
            font-family: Georgia, serif;
            line-height: 1.6;
            padding: 0 20px;
        }
        h1 { color: #2c3e50; }
        .references {
            margin-top: 40px;
            border-top: 1px solid #ddd;
            padding-top: 20px;
        }
        .references ol { line-height: 1.8; }
    </style>
  </head>
  <body>
    $htmlbody
    $bibliographyhtml
  </body>
</html>
"""

write("article.html", fullhtml)

println("  4.  article transformé !")
