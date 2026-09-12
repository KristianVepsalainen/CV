# CV — Kristian Vepsäläinen

Kaksi lähdetiedostoa, kuusi PDF:ää. Kytkimet tiedostojen alussa:

| `\consulting` | `\onepager` | Tulos |
|---|---|---|
| `false` | `false` | Työnhakuversio, 3 s. |
| `true`  | `false` | Konsulttiversio, 3 s. (eri osiojärjestys + "Miten työskentelen") |
| `false` | `true`  | Yksisivuinen, molempiin käyttöihin |

Sisältö on määritelty kerran makroina (`\SecSkills`, `\SecExperience`, …) ja
tulostetaan versiokohtaisessa järjestyksessä tiedoston lopussa. Muokkaa sisältöä
makroissa, järjestystä lopun `\ifconsulting`-lohkossa.

## Käyttöönotto

```bash
git clone <repo>
cd cv
cp contact-fi.example.tex contact-fi.tex
cp contact-en.example.tex contact-en.tex
# täytä puhelinnumero molempiin
make
```

## Puhelinnumero ja git

`contact-fi.tex` ja `contact-en.tex` ovat `.gitignore`ssa. Ne sisältävät
puhelinnumeron; muu yhteystieto (sähköposti, kotisivu, LinkedIn) on julkista jo
verkossa, mutta numero kulkee samassa lohkossa, joten koko lohko on jätetty
ulkopuolelle.

**Tämä toimii vain, jos numero ei ole koskaan ollut commitissa.** Git-historia on
pysyvä: jos numero on kerran viety, sen poistaminen myöhemmin ei poista sitä
vanhoista commiteista eikä forkeista. Tarkista ennen ensimmäistä pushia:

```bash
git status --short          # contact-*.tex ei saa näkyä
git grep -n "050 371"       # ei osumia
```

Jos numero on jo mennyt historiaan, helpoin korjaus on aloittaa repo alusta
(`rm -rf .git && git init`) ennen kuin se on missään julkisessa.

Käännös kaatuu selkeään virheilmoitukseen, jos `contact-*.tex` puuttuu — se on
tarkoituksellista, jotta tyhjää yhteystietolohkoa ei vahingossa julkaista.

## Kääntäminen

| Tapa | Komento |
|---|---|
| RStudio, Build-paneeli | Build All (projektin build type on Makefile) |
| RStudio, konsoli | `source("build.R")` |
| Terminaali | `make` / `make fi` / `make clean` |
| Yksi versio | `make cv_en_onepager.pdf` |

`build.sh` tekee saman kuin `make`, jos Makefilea ei halua käyttää.

Jokainen versio käännetään kahdesti, jotta `\pageref{LastPage}` ratkeaa.

## Riippuvuudet

`moderncv` 1.2.0 ja sen tyylitiedostot ovat repossa mukana, joten TeX Liven
versio ei vaikuta taittoon. Tarvitaan `pdflatex` sekä `lmodern`-fontit
(TeX Live full, tai `tlmgr install lmodern`). Ilman `lmodern`ia microtype kaatuu
virheeseen *auto expansion is only possible with scalable fonts*; kiertotie on
lisätä ennen `\documentclass`-riviä:

```latex
\PassOptionsToPackage{expansion=false,protrusion=false}{microtype}
```

## Muokkausvinkkejä

- Sivumäärä on tiukka. Osiovälit on kavennettu (`\addvspace{1.3ex}` /
  `0.6ex`) ja luettelomerkkien rivivälit nollattu `\itemhook`issa. Jos lisäät
  sisältöä ja versio valuu neljännelle sivulle, kasvata arvoja ja hyväksy lisäsivu
  tai karsi muualta.
- Valokuva on kommentoitu pois. Suomessa kuva on tavallinen, kansainvälisissä
  hauissa ei.
- `\ifconsulting`-ehtoja on myös sisältöjen sisällä: nimikehistoria ja vanha
  opetus- ja kustannustyö näkyvät vain työnhakuversiossa.
