%% Do not edit this file; it is auto-generated from input/new
%% This file is in the public domain.
%% Note: this file works from version 2.12.0
\version "2.12.0"

\header {
%% Translation of GIT committish: 740b9a6c16eb30a84b216d23aeb848aa1b632be6
  texidoces = "
La propiedad @code{measureLength} determina dónde se deben insertar
líneas divisorias y, con @code{beatLength} y @code{beatGrouping}, cómo
se deben generar las barras autoomáticas para las duraciones de barra
y compases para los que no hay ninguna regla definida para los finales
de barra. Este ejemplo muestra distintas dormas de controlar el
barrado mediante el establecimiento de estas propiedades. Las
explicaciones están en forma de comentarios dentro del código.

"
  doctitlees = "Utilización de beatLength y beatGrouping"

%% Translation of GIT committish: 0364058d18eb91836302a567c18289209d6e9706
  texidocde = "
Die Eigenschaft @code{measureLength} bestimmt, wo Taktstriche eingefügt
werden sollen und, zusammen mit @code{beatLength} und
@code{beatGrouping}, wie automtische Balken für Notenlängen und
Taktarten, für die keine definierten Regeln gefunden werden, gesetzt
werden sollen.  Dieses Beispiel zeigt verschiedene Möglichkeiten,
die Balken zu kontrollieren, indem man diese Eigenschaften
beeinflusst.  Die Erklärungen werden als Kommentare im Quellcode
gegeben.
"
  doctitlede = "beatLength und beatGrouping benutzen"

%% Translation of GIT committish: b3196fadd8f42d05ba35e8ac42f7da3caf8a3079
  texidocfr = "
La propriété @code{measureLength} détermine la pulsation et, combinée à
@code{beatLength} y @code{beatGrouping}, comment générer les ligatures
automatiques selon les durées et la métrique lorsqu'aucune règle n'a été
définie.  L'exemple commenté qui suit indique différentes façons de
contrôler les ligatures à l'aide de ces propriétés. 

"
  doctitlefr = "Utilisation conjointe de beatLength et beatGrouping"

  lsrtags = "rhythms"
  texidoc = "
The property @code{measureLength} determines where bar lines
should be inserted and, with @code{beatLength} and
@code{beatGrouping}, how automatic beams should be generated
for beam durations and time signatures for which no beam-ending
rules are defined.  This example shows several ways of controlling
beaming by setting these properties.  The explanations are shown
as comments in the code.
"
  doctitle = "Using beatLength and beatGrouping"
} % begin verbatim


\relative c'' {
  \time 3/4
  % The default in 3/4 time is to beam in three groups
  % each of a quarter note length
  a16 a a a a a a a a a a a

  \time 12/16
  % No auto-beaming is defined for 12/16
  a16 a a a a a a a a a a a

  \time 3/4
  % Change time signature symbol, but retain underlying 3/4 beaming
  \set Score.timeSignatureFraction = #'(12 . 16)
  a16 a a a a a a a a a a a

  % The 3/4 time default grouping of (1 1 1) and beatLength of 1/8
  % are not consistent with a measureLength of 3/4, so the beams
  % are grouped at beatLength intervals
  \set Score.beatLength = #(ly:make-moment 1 8)
  a16 a a a a a a a a a a a

  % Specify beams in groups of (3 3 2 3) 1/16th notes
  % 3+3+2+3=11, and 11*1/16<>3/4, so beatGrouping does not apply,
  % and beams are grouped at beatLength (1/16) intervals
  \set Score.beatLength = #(ly:make-moment 1 16)
  \set Score.beatGrouping = #'(3 3 2 3)
  a16 a a a a a a a a a a a

  % Specify beams in groups of (3 4 2 3) 1/16th notes
  % 3+4+2+3=12, and 12*1/16=3/4, so beatGrouping applies
  \set Score.beatLength = #(ly:make-moment 1 16)
  \set Score.beatGrouping = #'(3 4 2 3)
  a16 a a a a a a a a a a a
}

