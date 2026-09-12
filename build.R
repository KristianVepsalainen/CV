# Build all six CVs from RStudio:
#   source("build.R")
# Requires pdflatex on the PATH (TeX Live / TinyTeX).

# --- check the toolchain is actually visible to R --------------------------
if (nchar(Sys.which("pdflatex")) == 0) {
  stop("pdflatex is not on RStudio's PATH.\n",
       "  Terminal: which pdflatex\n",
       "  If it works there but not here, restart RStudio, or set the path with\n",
       "  Sys.setenv(PATH = paste(Sys.getenv('PATH'), '/usr/bin', sep = ':'))")
}

variants <- data.frame(
  src        = c("cv_fi.tex", "cv_fi.tex", "cv_fi.tex", "cv_en.tex", "cv_en.tex", "cv_en.tex"),
  consulting = c("false", "true", "false", "false", "true", "false"),
  onepager   = c("false", "false", "true", "false", "false", "true"),
  out        = c("cv_fi_tyonhaku.pdf", "cv_fi_konsultointi.pdf", "cv_fi_yksisivuinen.pdf",
                 "cv_en_employment.pdf", "cv_en_consulting.pdf", "cv_en_onepager.pdf"),
  stringsAsFactors = FALSE
)

failed <- character(0)

for (i in seq_len(nrow(variants))) {
  v <- variants[i, ]

  contact <- if (grepl("cv_fi", v$src)) "contact-fi.tex" else "contact-en.tex"
  if (!file.exists(contact)) {
    stop("Missing ", contact, " - copy ", sub("\\.tex$", ".example.tex", contact),
         " to ", contact, " and fill in your details.")
  }

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
    failed <- c(failed, v$out)
    # show the actual LaTeX error instead of pointing at a log we then delete
    if (file.exists("tmp_build.log")) {
      lg  <- readLines("tmp_build.log", warn = FALSE)
      err <- grep("^!", lg, value = TRUE)
      message("  !! ", v$out, " failed")
      if (length(err)) message("     ", paste(head(err, 3), collapse = "\n     "))
      file.copy("tmp_build.log", "build-error.log", overwrite = TRUE)
    }
    break   # all six fail the same way; no point repeating it five more times
  }
}

if (length(failed) == 0) {
  unlink(c("tmp_build.tex", "tmp_build.aux", "tmp_build.log", "tmp_build.out"))
  message("Done.")
} else {
  unlink(c("tmp_build.tex", "tmp_build.aux", "tmp_build.out"))
  message("\nBuild failed. Full log kept in build-error.log")
}
