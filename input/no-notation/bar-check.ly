\version "1.9.0"

\header {

texidoc = "skipTypesetting doesn't affect bar checks."

}

\score { \notes {
	\property Score.skipTypesetting = ##t
	c4 c4
	|
	c4 c4 }}
