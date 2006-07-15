======================================================================

                FPL Neu Fonts -- OpenType edition

                        (pre-release)
======================================================================

Supported OTL features and usage with xelatex
---------------------------------------------

Small caps exist only in the regular font for now:

,----
| c2sc    Small Capitals From Capitals
| smcp    Small Capitals
`----

When using \newfontinstance from fontconfig.sty one can use
'UprightFeatures={Letters=SmallCaps}' to avoid some warnings. For
example, one can use

\newfontinstance\spacedsc[LetterSpace=5.0,%
      UprightFeatures={Letters={SmallCaps,UppercaseSmallCaps}}]{FPL Neu}

to define a spaced, all small caps font instance. Standard \textsc{} or
\scshape work without problems.


Different figure forms:

,----
| case    Case-Sensitive Forms
| dnom    Denominators
| numr    Numerators
| onum    Oldstyle Figures
| sinf    Scientific Inferiors
| sups    Superscript
`----

xltxtra uses the 'sups' numbers for footnote indicators. Beware that 
for \textsuperscript and \textsubscript 'sups' and 'sinf' are used,
which suport only numbers at the moment. The 'numr' and 'denom' figures
can be used in conjunction with \vfrac from xltxtra.


Localization that switches U+015[ef] and U+016[23] from 'with cedilla'
to 'with commaaccent':

,----
| locl    Localized Forms  (latin script, Romanian language)
| ss01    Stylistic Set 1
`----

Localiced forms can be used with:

\newfontfeature{LocalForms}{+locl}
[...]
\addfontfeatures{Language=Romanian,LocalForms}


License
-------

Copyright (URW)++,Copyright 1999 by (URW)++ Design & Development
Copyright 2000, 2002 Diego Puga 
Copyright 2004--2006 Ralf Stubner

See the file COPYING (GNU General Public License) for license
conditions. As a special exception, permission is granted to include
this font program in a Postscript or PDF file that consists of a
document that contains text to be displayed or printed using this font,
regardless of the conditions or license applying to the document itself.

== The End ==
