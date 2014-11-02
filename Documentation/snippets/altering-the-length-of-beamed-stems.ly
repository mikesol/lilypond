%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.di.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.18.0"

\header {
  lsrtags = "pitches, tweaks-and-overrides"

  texidoc = "
Stem lengths on beamed notes can be varied by overriding the
@code{beamed-lengths} property of the @code{details} of the
@code{Stem}.  If a single value is used as an argument, the length
applies to all stems.  When multiple arguments are used, the first
applies to eighth notes, the second to sixteenth notes and so on.  The
final argument also applies to all notes shorter than the note length
of the final argument.  Non-integer arguments may also be used.

"
  doctitle = "Altering the length of beamed stems"
} % begin verbatim

\relative c'' {
  \override Stem.details.beamed-lengths = #'(2)
  a8[ a] a16[ a] a32[ a]
  \override Stem.details.beamed-lengths = #'(8 10 12)
  a8[ a] a16[ a] a32[ a] r8
  \override Stem.details.beamed-lengths = #'(8)
  a8[ a]
  \override Stem.details.beamed-lengths = #'(8.5)
  a8[ a]
  \revert Stem.details
  a8[ a] a16[ a] a32[ a] r16
}
