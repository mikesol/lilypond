\version "1.5.68"


\score{
	\notes\transpose c'{
		\property Score.beamQuantisation = #'none

		[a'8 <a' g''>]
		[c <c e,>]
		[a'16 <a' g''>]
		[c <c e,>]
		[a'32 <a' g''>]
		[c <c e,>]
	}
	\paper{

		linewidth = 60.0\mm
	}
}
