# Time-stamp: <2006-06-25 13:51:33 ralf> 
# Copyright 2005, 2006 Ralf Stubner
# See the file COPYING (GNU General Public License) for license conditions. 

FONTFORGE=fontforge -script

COMMON=AddGPL AddException Version fplneu_att

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
#       * some general files
#
# currently not used:
#       * a FF file with new/fixed ATT/OTL tables
#
# Italic fonts also depend on:
#	* the weight corresponding roman SFD file (circled characters)
#
%i8a.sfd: %i8a.pe  %i8a-fix.sfd %i8a-fix.afm %i8a_hint $(COMMON) %8a.sfd
	$(FONTFORGE) $*i8a.pe

%8a.sfd: %8a.pe  %8a-fix.sfd %8a-fix.afm %8a_hint $(COMMON)
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

.PHONY: dist check type1 opentype truetype

# don't delete intermediate sfd files
.SECONDARY:
