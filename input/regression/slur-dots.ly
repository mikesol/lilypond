#(ly:set-option 'old-relative)
\version "1.9.0"
\header{
texidoc="Slurs should not get confused by augmentation dots.  We use a lot
of dots here, to make problems more visible."
}
\score {
  \notes\relative c'' {
    c4.............-( c-)
  }
  \paper {
    raggedright = ##t
  }
}


