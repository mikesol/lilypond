%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.di.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.18.0"

\header {
  lsrtags = "fretted-strings"

  texidoc = "
Slides for chords are indicated by default in both @code{Staff} and
@code{TabStaff}. String numbers are necessary for @code{TabStaff}
because automatic string calculations are different for chords and for
single notes.

"
  doctitle = "Chord glissando in tablature"
} % begin verbatim
%=> http://lilypond.1069038.n5.nabble.com/LSR-chord-glissando-in-tablature-obsolete-tc159863.html

myMusic = \relative c' {
  <c e g>1 \glissando <f a c>
}

\score {
  <<
    \new Staff {
      \clef "treble_8"
      \myMusic
    }
    \new TabStaff \myMusic
  >>
}

\score {
  <<
    \new Staff {
      \clef "treble_8"
      \myMusic
    }
    \new TabStaff \with { \override Glissando.style = #'none } {
      \myMusic
    }
  >>
}
