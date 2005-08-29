# Time-stamp: <2005-08-29 20:08:36 ralf> 
# Copyright 2005 Ralf Stubner
# See the file COPYING (GNU General Public License) for license conditions. 

FONTFORGE=fontforge -script

default: type1

all: type1

#
# Every font depends on: 
# 	* the PE script which creates it
# 	* a SFD file with new/fixed glyphs
#	* a AFM file with new/fixed metrics
#       * a FF file with new/fixed hinting 
#
# Italic fonts also depend on:
#	* the weight corresponding roman SFD file (circled characters)
#
%i8a.sfd: %i8a.pe  %i8a-fix.sfd %i8a-fix.afm %i8a_hint %8a.sfd
	$(FONTFORGE) $*i8a.pe

%8a.sfd: %8a.pe  %8a-fix.sfd %8a-fix.afm %8a_hint
	$(FONTFORGE) $*8a.pe

# Type1 creation
%.pfb: %.sfd
	$(FONTFORGE) generate-type1.pe $*.sfd

type1: fp9r8a.pfb fp9ri8a.pfb fp9b8a.pfb fp9bi8a.pfb

# OTF creation
%.otf: %.sfd
	$(FONTFORGE) generate-otf.pe $*.sfd

opentype: fp9r8a.otf fp9ri8a.otf fp9b8a.otf fp9bi8a.otf

# TTF creation
%.ttf: %.sfd
	$(FONTFORGE) generate-ttf.pe $*.sfd

truetype: fp9r8a.ttf fp9ri8a.ttf fp9b8a.ttf fp9bi8a.ttf

# check the Type1 fonts for some common errors
check: type1
	for font in fp9r8a.pfb fp9ri8a.pfb fp9b8a.pfb fp9bi8a.pfb; do \
	     echo -en $${font}"\t"; \
	     t1disasm $${font} | egrep --count 'div[^i]'; \
	     t1lint $${font}; \
	done

# prepare Type1 fonts for distribution
dist: type1
	rm -rf dist/
	mkdir -p dist/fonts/{type1,afm}/public/fplneu
	cp fp9r8a.pfb fp9ri8a.pfb fp9b8a.pfb fp9bi8a.pfb dist/fonts/type1/public/fplneu/
	cp fp9r8a.pfm fp9ri8a.pfm fp9b8a.pfm fp9bi8a.pfm dist/fonts/type1/public/fplneu/
	cp fp9r8a.afm fp9ri8a.afm fp9b8a.afm fp9bi8a.afm dist/fonts/afm/public/fplneu/
	(cd dist; zip -r fp9-fonts.zip fonts/)

.PHONY: dist check type1 opentype truetype

# don't delete intermediate sfd files
.SECONDARY: