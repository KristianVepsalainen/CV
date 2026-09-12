#!/usr/bin/env bash
# Builds all six CVs from the two .tex sources by flipping the two switches.
#
#   cv_fi_tyonhaku.pdf     cv_fi_konsultointi.pdf     cv_fi_yksisivuinen.pdf
#   cv_en_employment.pdf   cv_en_consulting.pdf       cv_en_onepager.pdf
#
# Usage: ./build.sh        (needs pdflatex; run from this directory)

set -e

build () {
  local src="$1" cons="$2" one="$3" out="$4"
  sed -e "s/^\\\\consultingfalse\$/\\\\consulting${cons}/" \
      -e "s/^\\\\onepagerfalse\$/\\\\onepager${one}/" "$src" > tmp_build.tex
  pdflatex -interaction=nonstopmode tmp_build.tex > /dev/null || true
  pdflatex -interaction=nonstopmode tmp_build.tex > /dev/null || true   # twice, for \pageref{LastPage}
  if [ ! -f tmp_build.pdf ]; then echo "  !! $out failed - see tmp_build.log"; return 1; fi
  mv tmp_build.pdf "$out"
  echo "  -> $out"
}

echo "Building:"
build cv_fi.tex false false cv_fi_tyonhaku.pdf
build cv_fi.tex true  false cv_fi_konsultointi.pdf
build cv_fi.tex false true  cv_fi_yksisivuinen.pdf
build cv_en.tex false false cv_en_employment.pdf
build cv_en.tex true  false cv_en_consulting.pdf
build cv_en.tex false true  cv_en_onepager.pdf

rm -f tmp_build.aux tmp_build.log tmp_build.out tmp_build.tex
echo "Done."
