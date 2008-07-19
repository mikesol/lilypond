%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.11.52"

\header {
  lsrtags = "staff-notation, contexts-and-engravers"

  texidoces = "
Se puede usar el delimitador de comienzo de un sistema
@code{SystemStartSquare} estableciéndolo explícitamente dentro de
un contexto @code{StaffGroup} o @code{ChoirStaffGroup}.

"
  doctitlees = "Uso del corchete recto al comienzo de un grupo de pentagramas"

  texidoc = "
The system start delimiter @code{SystemStartSquare} can be used by
setting it explicitly in a @code{StaffGroup} or @code{ChoirStaffGroup}
context. 

"
  doctitle = "Use square bracket at the start of a staff group"
} % begin verbatim
\score {
  \new StaffGroup { << 
  \set StaffGroup.systemStartDelimiter = #'SystemStartSquare
    \new Staff { c'4 d' e' f' }
    \new Staff { c'4 d' e' f' }
  >> }
}
