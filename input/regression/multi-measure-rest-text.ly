\version "2.17.6"

\header  {

  texidoc = "
Texts may be added to the multi-measure rests.

By setting the appropriate @code{spacing-procedure}, we can make
measures stretch to accommodate wide texts.

"


}

\book { \score { {
  \time 3/4
  \set Score.skipBars = ##t
  R2._\markup { \center-column { \musicglyph  #"scripts.dfermata" \roman "Ad lib"  }  }
  R2.^\fermataMarkup
  R2.^"4"
  R2.*3_\markup { \roman "a1b2c3" }
  R2.*10^"inner"^"top"_"inner"_"bot"
  \override MultiMeasureRestText.springs-and-rods
    = #ly:multi-measure-rest::set-text-rods

  R2.^"very very very very very very long text"
  c'2.
}
  \layout { ragged-right = ##t }
}}
