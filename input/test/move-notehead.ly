\version "1.5.68"


fragment = \notes {
    \outputproperty #(make-type-checker 'note-head-interface)
      #'extra-offset = #'(2 . 3)
    c''2 c
}

\paper { linewidth = -1. } 

\score {
  \notes\relative c \fragment
  \paper { }  
}
