%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.di.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.18.0"

\header {
  lsrtags = "keyboards, real-music, repeats"

  texidoc = "
Since @code{\\repeat tremolo} expects exactly two musical arguments for
chord tremolos, the note or chord which changes staff within a
cross-staff tremolo should be placed inside curly braces together with
its @code{\\change Staff} command.

"
  doctitle = "Cross-staff tremolos"
} % begin verbatim

\new PianoStaff <<
  \new Staff = "up" \relative c'' {
    \key a \major
    \time 3/8
    s4.
  }
  \new Staff = "down" \relative c'' {
    \key a \major
    \time 3/8
    \voiceOne
    \repeat tremolo 6 {
      <a e'>32
      {
        \change Staff = "up"
        \voiceTwo
        <cis a' dis>32
      }
    }
  }
>>
