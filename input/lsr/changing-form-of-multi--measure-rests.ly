%% Do not edit this file; it is auto-generated from input/new
%% This file is in the public domain.
\version "2.11.42"
\layout { ragged-right= ##t }
\header {
  doctitle = "Changing form of multi-measure rests"
  lsrtags = "rhythms,tweaks-and-overrides"
  texidoc = "
If there are ten or fewer measures of rests, LilyPond prints
a series of longa and breve rests (called in German
\"Kirchenpausen\" - church rests) within the staff and
prints a simple line otherwise.  This default number of ten
may be changed by an override:
"} % begin verbatim

\relative c'' {
  \compressFullBarRests
  R1*2 | R1*5 | R1*9
  \override MultiMeasureRest #'expand-limit = 3
  R1*2 | R1*5 | R1*9
}
