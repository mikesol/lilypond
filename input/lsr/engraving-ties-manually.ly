%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.11.52"

\header {
  lsrtags = "rhythms"

 doctitlees = "Grabado manual de las ligaduras"
 texidoces = "
Se pueden grabar a mano las ligaduras modificando la propiedad
@code{tie-configuration} del objeto @code{TieColumn}. El primer número
indica la distancia a partir de la tercera línea del pentagrama en
espacios de pentagrama, y el segundo número indica la dirección (1 =
hacia arriba, -1 = hacia abajo).

"
  texidoc = "
Ties may be engraved manually by changing the @code{tie-configuration}
property of the @code{TieColumn} object. The first number indicates the
distance from the center of the staff in staff-spaces, and the second
number indicates the direction (1 = up, -1 = down).

"
  doctitle = "Engraving ties manually"
} % begin verbatim
\relative c' {
  <c e g>2 ~ <c e g>
  \override TieColumn #'tie-configuration =
    #'((0.0 . 1) (-2.0 . 1) (-4.0 . 1))
  <c e g> ~ <c e g>
}
