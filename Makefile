# Time-stamp: <2006-07-18 00:25:03 ralf> 
# Copyright 2005, 2006 Ralf Stubner
# See the file COPYING (GNU General Public License) for license conditions. 

FONTFORGE=fontforge -script

COMMON=Common AddGPL AddException fplneu_att CombiningMarks BuildMark regular-crp.sfd bold-crp.sfd
# regular-crp.sfd bold-crp.sfd aren't strictly COMMON, 
# but it is easier that way ...

PFB=fp9r8a.pfb fp9ri8a.pfb fp9b8a.pfb fp9bi8a.pfb
AFM=$(patsubst %.pfb,%.afm,$(PFB))
PFM=$(patsubst %.pfb,%.pfm,$(PFB))
TTF=$(patsubst %.pfb,%.ttf,$(PFB))
OTF=$(patsubst %.pfb,%.otf,$(PFB))

DOC=CHANGES COPYING

default: type1

all: type1 opentype truetype

#
# Every font depends on: 
# 	* the PE script which creates it
# 	* a SFD file with new/fixed glyphs
#	* a AFM file with new/fixed metrics
#       * a FF file with new/fixed hinting 
#       * a FF file with new/fixed ATT/OTL tables
#       * some general files
%8a.sfd: %8a.pe  %8a-fix.sfd %8a-fix.afm %8a_hint %8a_att $(COMMON)
	$(FONTFORGE) $*8a.pe

# Type1 creation
%.pfb: %.sfd
	$(FONTFORGE) generate-type1.pe $*.sfd

type1: $(PFB)

# OTF creation
%.otf: %.sfd
	$(FONTFORGE) generate-otf.pe $*.sfd

opentype: $(OTF)

# TTF creation
%.ttf: %.sfd
	$(FONTFORGE) generate-ttf.pe $*.sfd

truetype: $(TTF)

# fonts with copyright, registered, produced signes
crp-fonts: regular-crp.pe bold-crp.pe
	$(FONTFORGE) regular-crp.pe 
	$(FONTFORGE) bold-crp.pe

# check the Type1 fonts for some common errors
check: type1
	for f in dist/fonts/afm/public/fplneu/*; do \
	     n=$$(basename $$f); \
	     afmdiff.awk $$f $$n | less ; \
        done
	for font in $(PFB); do \
	     t1disasm $${font} | egrep --with-filename --label=$${font} --count 'div[^i]'; \
	     t1lint $${font}; \
	done

# Testpage
FPLNeu.pdf: type1
	(for font in $(PFB); do t1testpage $${font}; done) | ps2pdf - > $@

# prepare Type1 fonts for distribution
dist: type1
	rm -rf dist/
	mkdir -p dist/fonts/type1/public/fplneu
	mkdir -p dist/fonts/afm/public/fplneu
	mkdir -p dist/doc/fonts/fplneu
	cp $(PFB) dist/fonts/type1/public/fplneu/
	cp $(PFM) dist/fonts/type1/public/fplneu/
	cp $(AFM) dist/fonts/afm/public/fplneu/
	cp $(DOC) dist/doc/fonts/fplneu/
	(cd dist; zip -r fp9-fonts.zip fonts/ doc/)

# prepare OpenType fonts for distribution
dist-otf: opentype
	rm -rf dist-otf/
	mkdir dist-otf
	cp $(OTF) dist-otf/
	cp $(DOC) dist-otf/
	cp README.opentype dist-otf/README
	(cd dist-otf; zip -r fplneu-otf.zip *)

.PHONY: dist dist-otf check type1 opentype truetype crp-fonts

# don't delete intermediate sfd files
.SECONDARY:
