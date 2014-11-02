%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.di.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.18.0"

\header {
  lsrtags = "rhythms, tweaks-and-overrides"

  texidoc = "
In @qq{simple} lead-sheets, sometimes no actual notes are written,
instead only @qq{rhythmic patterns} and chords above the measures are
notated giving the structure of a song. Such a feature is for example
useful while creating/transcribing the structure of a song and also
when sharing lead sheets with guitarists or jazz musicians. The
standard support for this using @code{\\repeat percent} is unsuitable
here since the first beat has to be an ordinary note or rest. This
example shows two solutions to this problem, by redefining ordinary
rests to be printed as slashes. (If the duration of each beat is not a
quarter note, replace the @code{r4} in the definitions with a rest of
the appropriate duration).

"
  doctitle = "Rhythmic slashes"
} % begin verbatim

% Macro to print single slash
rs = {
  \once \override Rest.stencil = #ly:percent-repeat-item-interface::beat-slash
  \once \override Rest.thickness = #0.48
  \once \override Rest.slope = #1.7
  r4
}

% Function to print a specified number of slashes
comp = #(define-music-function (parser location count) (integer?)
  #{
    \override Rest.stencil = #ly:percent-repeat-item-interface::beat-slash
    \override Rest.thickness = #0.48
    \override Rest.slope = #1.7
    \repeat unfold $count { r4 }
    \revert Rest.stencil
  #}
)

\score {
  \relative c' {
    c4 d e f |
    \rs \rs \rs \rs |
    \comp #4 |
  }
}
