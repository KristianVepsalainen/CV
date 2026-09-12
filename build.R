# Build all six CVs from RStudio without the Build pane:
#   source("build.R")
# Requires pdflatex on the PATH (TeX Live / TinyTeX).

variants <- data.frame(
  src       = c("cv_fi.tex", "cv_fi.tex", "cv_fi.tex", "cv_en.tex", "cv_en.tex", "cv_en.tex"),
  consulting= c("false", "true", "false", "false", "true", "false"),
  onepager  = c("false", "false", "true", "false", "false", "true"),
  out       = c("cv_fi_tyonhaku.pdf", "cv_fi_konsultointi.pdf", "cv_fi_yksisivuinen.pdf",
                "cv_en_employment.pdf", "cv_en_consulting.pdf", "cv_en_onepager.pdf"),
  stringsAsFactors = FALSE
)

for (i in seq_len(nrow(variants))) {
  v <- variants[i, ]
  src <- readLines(v$src, warn = FALSE)
  src <- sub("^\\\\consultingfalse$", paste0("\\\\consulting", v$consulting), src)
  src <- sub("^\\\\onepagerfalse$",   paste0("\\\\onepager",   v$onepager),   src)
  writeLines(src, "tmp_build.tex")

  # twice, so \pageref{LastPage} resolves
  for (pass in 1:2) {
    system2("pdflatex", c("-interaction=batchmode", "tmp_build.tex"),
            stdout = FALSE, stderr = FALSE)
  }

  if (file.exists("tmp_build.pdf")) {
    file.rename("tmp_build.pdf", v$out)
    message("  -> ", v$out)
  } else {
    warning("FAILED: ", v$out, " (see tmp_build.log)")
  }
}

unlink(c("tmp_build.tex", "tmp_build.aux", "tmp_build.log", "tmp_build.out"))
message("Done.")
