\version "2.13.36"

\header {
  lsrtags="winds"
  texidoc="
The size and thickness of woodwind diagrams can be changed.
"

  doctitle = "Changing the size of woodwind diagrams"
}

\relative c'' {
  \textLengthOn
  c1^\markup
    \woodwind-diagram
      #'piccolo
      #'()

  c^\markup
    \override #'(size . 1.5) {
      \woodwind-diagram
        #'piccolo
        #'()
    }
  c^\markup
    \override #'(thickness . 0.15) {
      \woodwind-diagram
        #'piccolo
        #'()
    }
}
