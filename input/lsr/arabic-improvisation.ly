%% Do not edit this file; it is auto-generated from input/new
%% This file is in the public domain.
%% Note: this file works from version 2.12.0
\version "2.12.0"

\header {
%% Translation of GIT committish: 740b9a6c16eb30a84b216d23aeb848aa1b632be6
  texidoces = "
Para las improvisaciones o @emph{taqasim} que son libres durante unos
momentos, se puede omitir la indicación de compás y se puede usar
@code{\cadenzaOn}.  Podría ser necesario ajustar el estilo de
alteraciones accidentales, porque la ausencia de líneas divisorias
hará que la alteración aparezca una sola vez.  He aquí un ejemplo de
cómo podría ser el comienzo de una improvisación @emph{hijaz}:

"
doctitlees = "Improvisación de música árabe"

%% Translation of GIT committish: 33f623301a41fcc53efadf96bca1c72834763415
  texidocde = "
Bei Improvisation oder @emph{taqasim}, die zeitlich frei gespielt
werden, kann die Taktart ausgelassen werden und @code{\cadenzaOn}
kann eingesetzt werden.  Es kann nötig sein, den Versetzungszeichenstil
anzupassen, weil sonst die Versetzungszeichen nur einmal ausgegeben
werden, da keine Taktlinien gesetzt sind.  Hier ein Beispiel, wie
der Begin einer @emph{hijaz}-Improvisation aussehen könnte:

"

  doctitlede = "Arabische Improvisation"

  lsrtags = "world-music"
  texidoc = "For improvisations or @emph{taqasim} which are
temporarily free, the time signature can be omitted and
@code{\cadenzaOn} can be used.  Adjusting the accidental style
might be required, since the absence of bar lines will cause the
accidental to be marked only once.  Here is an example of what
could be the start of a @emph{hijaz} improvisation:"
doctitle = "Arabic improvisation"
} % begin verbatim


\include "arabic.ly"

\relative sol' {
  \key re \kurd
  #(set-accidental-style 'forget)
  \cadenzaOn
  sol4 sol sol sol fad mib sol1 fad8 mib re4. r8 mib1 fad sol
}
