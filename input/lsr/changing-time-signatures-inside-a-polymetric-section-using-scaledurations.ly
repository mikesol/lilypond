%% Do not edit this file; it is auto-generated from input/new
%% This file is in the public domain.
\version "2.13.1"
\header {
  texidoces = "
La propiedad @code{measureLength}, junto con
@code{measurePosition}, determina cuándo es necesario dibujar una
línea divisoria.  Sin embargo, al utilizar
@code{\\scaleDurations}, el escalado proporcional de las
duraciones hace difícil introducir cambios de compás.  En este
caso se debe establecer manualmente el valor de
@code{measureLength} utilizando la función @code{ly:make-moment}.
El segundo argumento debe ser el mismo que el segundo argumento de
@code{\\scaleDurations}.

"
  doctitlees = "Modificar el compás dentro de una sección polimétrica utilizando @code{\\scaleDurations}"

  lsrtags = "rhythms,contexts-and-engravers"
  texidoc = "The @code{measureLength} property, together with
@code{measurePosition}, determines when a bar line is needed.  However,
when using @code{\\scaleDurations}, the scaling of durations makes it
difficult to change time signatures.  In this case, @code{measureLength}
should be set manually, using the @code{ly:make-moment} callback.  The
second argument must be the same as the second argument of
@code{\\scaleDurations}."
  doctitle = "Changing time signatures inside a polymetric section using @code{\\scaleDurations}"
} % begin verbatim


\layout {
  \context {
    \Score
    \remove "Timing_translator"
    \remove "Default_bar_line_engraver"
  }
  \context {
    \Staff
    \consists "Timing_translator"
    \consists "Default_bar_line_engraver"
  }
}

<<
  \new Staff {
    \scaleDurations #'(8 . 5) {
      \time 6/8
      \set Timing.measureLength = #(ly:make-moment 6 5)
      b8 b b b b b
      \time 2/4
      \set Timing.measureLength = #(ly:make-moment 4 5)
      b4 b
    }
  }
  \new Staff {
    \clef bass
    \time 2/4
    c2 d e f
  }
>>
