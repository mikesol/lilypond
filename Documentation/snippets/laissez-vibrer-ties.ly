%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.di.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.18.0"

\header {
  lsrtags = "connecting-notes, contemporary-notation, expressive-marks, fretted-strings, keyboards, specific-notation"

  texidoc = "
Laissez vibrer ties have a fixed size. Their formatting can be tuned
using @code{'tie-configuration}.

"
  doctitle = "Laissez vibrer ties"
} % begin verbatim

\relative c' {
  <c e g>4\laissezVibrer r <c f g>\laissezVibrer r
  <c d f g>4\laissezVibrer r <c d f g>4.\laissezVibrer r8

  <c d e f>4\laissezVibrer r
  \override LaissezVibrerTieColumn.tie-configuration
     = #`((-7 . ,DOWN)
          (-5 . ,DOWN)
          (-3 . ,UP)
          (-1 . ,UP))
  <c d e f>4\laissezVibrer r
}
