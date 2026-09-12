# Build all six CVs.  RStudio: Build pane -> "Build All" runs `make`.
# Terminal: `make`, `make clean`, or a single target e.g. `make cv_en_onepager.pdf`.

FI_OUT = cv_fi_tyonhaku.pdf cv_fi_konsultointi.pdf cv_fi_yksisivuinen.pdf
EN_OUT = cv_en_employment.pdf cv_en_consulting.pdf cv_en_onepager.pdf

.PHONY: all clean fi en
all: $(FI_OUT) $(EN_OUT)
fi: $(FI_OUT)
en: $(EN_OUT)

# $(1) source  $(2) consulting flag  $(3) onepager flag
define BUILD
	@sed -e 's/^\\consultingfalse$$/\\consulting$(2)/' \
	     -e 's/^\\onepagerfalse$$/\\onepager$(3)/' $(1) > tmp_build.tex
	@pdflatex -interaction=batchmode tmp_build.tex > /dev/null || true
	@pdflatex -interaction=batchmode tmp_build.tex > /dev/null || true
	@test -f tmp_build.pdf || { echo "FAILED: $@ (see tmp_build.log)"; exit 1; }
	@mv tmp_build.pdf $@
	@echo "  -> $@"
endef

cv_fi_tyonhaku.pdf:     cv_fi.tex contact-fi.tex ; $(call BUILD,cv_fi.tex,false,false)
cv_fi_konsultointi.pdf: cv_fi.tex contact-fi.tex ; $(call BUILD,cv_fi.tex,true,false)
cv_fi_yksisivuinen.pdf: cv_fi.tex contact-fi.tex ; $(call BUILD,cv_fi.tex,false,true)
cv_en_employment.pdf:   cv_en.tex contact-en.tex ; $(call BUILD,cv_en.tex,false,false)
cv_en_consulting.pdf:   cv_en.tex contact-en.tex ; $(call BUILD,cv_en.tex,true,false)
cv_en_onepager.pdf:     cv_en.tex contact-en.tex ; $(call BUILD,cv_en.tex,false,true)

contact-fi.tex contact-en.tex:
	@echo "Missing $@ — copy $(basename $@).example.tex to $@ and fill in your details."
	@exit 1

clean:
	@rm -f tmp_build.* *.aux *.log *.out
	@echo "Cleaned."
