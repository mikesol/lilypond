\header{
filename =	 "clarinetti.ly";
% %title =	 "Ouvert\\"ure zu Collins Trauerspiel \\"Coriolan\\" Opus 62";
description =	 "";
composer =	 "Ludwig van Beethoven (1770-1827)";
enteredby =	 "JCN";
copyright =	 "public domain";


}

\version "1.3.4";

\include "clarinetto-1.ly"
\include "clarinetto-2.ly"

$clarinetti_staff = \context Staff = clarinetti <
	\property Staff.midiInstrument = #"clarinet"
	\property Staff.instrument = #"2 Clarinetti (B\\textflat)"
	\property Staff.instr = #"Cl. (B\\textflat)"
	% urg: can't; only My_midi_lexer:<non-static> () parses pitch?
	%\property Staff.transposing = "bes"
	\property Staff.transposing = #-2
	%\notes \context Voice=clarinetti < 
	\notes \context Staff=clarinetti < 
		\time 4/4;
		\key F;
		\context VoiceOne=clarinettoi
			\$clarinetto1
		\context VoiceTwo=clarinettoii
			\$clarinetto2
	>
>

