%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.13.1"

\header {
  lsrtags = "expressive-marks, unfretted-strings"

  doctitlees = "Marca de pizzicato de chasquido (@q{pizzicato de Bartók})"
  texidoces = "
El pizzicato de chasquido (también llamado @q{Pizzicato de Bartók}) es un
@q{pizzicato fuerte en que la cuerda se pulsa verticalmente produciendo un
chasquido y rebotando en el diapasón del instrumento} (Wikipedia).  Se
denota mediante una circunferencia con una línea vertical corta que parte
del centro de aquélla hacia fuera.  Aunque Lilypond no tiene ninguna
instrucción predefinida para crear esta marca, es fácil hacer la definición
y colocarla directamente en el archivo de lilypond.
"

  doctitlede = "Bartók-Pizzicato"
  texidocde = "
Das Bartók-Pizzicato @q{ist eine besondere Form des Pizzicato, bei dem der
Spieler die Saite auf das Griffbrett aufschlagen lässt, sodass zusätzlich
zum angeschlagenen Ton ein scharfes, knallendes Geräusch ertönt}
(Wikipedia).  Es wird dargestellt als kleiner Kreis mit einer vertikalen
Linie, die vom Kreiszentrum aus nach oben weist und ein Stück außerhalb des
Kreises endet.  Lilypond hat keinen eigenen Glyphen für dieses Symbol; es
ist aber einfach, direkt eine Definition in die Eingabedatei einzufügen.
"

  texidoc = "
A snap-pizzicato (also known as \"Bartok pizzicato\") is a \"strong
pizzicato where the string is plucked vertically by snapping and
rebounds off the fingerboard of the instrument\" (Wikipedia). It is
denoted by a cicle with a vertical line going from the center upwards
outside the circle. While Lilypond does not have a pre-defined command
to created this markup, it is easy to create a definition and place it
directly into the lilypond file. 

"
  doctitle = "Snap-pizzicato markup (\"Bartok pizzicato\")"
} % begin verbatim

#(define-markup-command (snappizz layout props) ()
  (interpret-markup layout props
    (markup #:stencil
      (ly:stencil-translate-axis
        (ly:stencil-add
          (make-circle-stencil 0.7 0.1 #f)
          (ly:make-stencil
            (list 'draw-line 0.1 0 0.1 0 1)
            '(-0.1 . 0.1) '(0.1 . 1)))
        0.7 X))))

snapPizzicato = \markup \snappizz

% now it can be used as \snappizzicato after the note/chord
% Note that a direction (-, ^ or _) is required.
\relative c' {
  c4^\snapPizzicato
  % This does NOT work:
  %<c e g>\snapPizzicato
  <c' e g>-\snapPizzicato
  <c' e g>^\snapPizzicato
  <c, e g>_\snapPizzicato
}
