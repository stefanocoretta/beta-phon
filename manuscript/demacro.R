input <- "manuscript/manuscript.tex"
output <- "manuscript/manuscript-code-only.txt"

x <- readLines(input)

# Keep lines between \begin{Shaded} and \end{Shaded}
inside <- FALSE
code <- character()

for (line in x) {
  if (grepl("\\\\begin\\{Shaded\\}", line)) {
    inside <- TRUE
    next
  }
  if (grepl("\\\\end\\{Shaded\\}", line)) {
    inside <- FALSE
    code <- c(code, "") # blank line between code blocks
    next
  }
  if (inside) code <- c(code, line)
}

# Remove LaTeX macros used for syntax highlighting
code <- gsub("\\\\(AttributeTok|FunctionTok|NormalTok|StringTok|CommentTok|KeywordTok|DecValTok|OperatorTok|ControlFlowTok|ConstantTok|AlertTok|DataTypeTok|OtherTok|SpecialCharTok|VariableTok|BuiltInTok|ExtensionTok|FloatTok|CharTok|BaseNTok|ImportTok|DocumentationTok|AnnotationTok|CommentVarTok|RegionMarkerTok|InformationTok|WarningTok|ErrorTok)\\{([^}]*)\\}", "\\2", code)

# Drop \begin{Highlighting} etc.
code <- gsub("\\\\begin\\{Highlighting\\}\\[?[^\\]]*\\]?", "", code)
code <- gsub("\\\\end\\{Highlighting\\}", "", code)

writeLines(code, output)
