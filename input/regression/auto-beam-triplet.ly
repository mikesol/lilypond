#(ly:set-option 'old-relative)
\header
{
texidoc = "Automatic beaming is also done on tuplets."
}

\version "1.9.0"

\score{
	\notes\relative c''{
		c8 c c c
		\times 4/6 { c c c c c c}
	}
    \paper { raggedright= ##t }
}
