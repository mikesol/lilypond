\version "1.7.16"


fragment = \notes {
  \context Voice {
    \property Voice.crescendoText = "cresc."
    \property Voice.crescendoSpanner = #'dashed-line
    a''2-\mf\< a a \!a
  }
}

\paper { raggedright = ##t} 

\score {
  \notes\relative c \fragment
  \paper { }  
}
%% new-chords-done %%
