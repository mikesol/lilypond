#(ly:set-option 'old-relative)
\header {
texidoc = "@cindex Ancient Accidentals
Accidentals are available in different ancient styles. This
file lists all of them.
"
}

\version "1.9.0"

\score { 
  \context Voice \notes\relative c {
    \time 3/4
	\property Staff.Accidental \set #'style = #'default
	cisis''^"Accidental style = \#'default" cisis! cisis? |
	cis cis! cis? | 
	c c! c? |
	ces ces! ces? |
	ceses ceses! ceses? |
	\break
	
	\property Staff.Accidental \set #'style = #'hufnagel
	cisis^"Accidental style = \#'hufnagel" cisis! cisis? |
	cis cis! cis? | 
	c c! c? |
	ces ces! ces? |
	ceses ceses! ceses? |
	\break
	
	\property Staff.Accidental \set #'style = #'medicaea
	cisis^"Accidental style = \#'medicaea" cisis! cisis? |
	cis cis! cis? | 
	c c! c? |
	ces ces! ces? |
	ceses ceses! ceses? |
	\break
	
	\property Staff.Accidental \set #'style = #'vaticana
	cisis^"Accidental style = \#'vaticana" cisis! cisis? |
	cis cis! cis? | 
	c c! c? |
	ces ces! ces? |
	ceses ceses! ceses? |
	\break
	
	\property Staff.Accidental \set #'style = #'mensural
	cisis^"Accidental style = \#'mensural" cisis! cisis? |
	cis cis! cis? | 
	c c! c? |
	ces ces! ces? |
	ceses ceses! ceses? |
	
  }
}

