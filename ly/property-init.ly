% property-init.ly

\version "2.1.21"

stemUp = \property Voice.Stem \set #'direction = #1
stemDown = \property Voice.Stem \set #'direction = #-1 
stemBoth= \property Voice.Stem \revert #'direction

slurUp   = \property Voice.Slur \set #'direction = #1
slurDown = \property Voice.Slur \set #'direction = #-1
slurBoth = \property Voice.Slur \revert #'direction 

% There's also dash, but setting dash period/length should be fixed.
slurDotted = \property Voice.Slur \set #'dashed = #1
slurSolid = \property Voice.Slur \revert #'dashed


phrasingSlurUp   = \property Voice.PhrasingSlur \set #'direction = #1
phrasingSlurDown = \property Voice.PhrasingSlur \set #'direction = #-1
phrasingSlurBoth = \property Voice.PhrasingSlur \revert #'direction 

shiftOn  = \property Voice.NoteColumn \set #'horizontal-shift = #1
shiftOnn  = \property Voice.NoteColumn \set #'horizontal-shift = #2
shiftOnnn  = \property Voice.NoteColumn \set #'horizontal-shift = #3
shiftOff  = \property Voice.NoteColumn \revert #'horizontal-shift 

tieUp = \property Voice.Tie \set #'direction = #1
tieDown = \property Voice.Tie \set #'direction = #-1
tieBoth = \property Voice.Tie \revert #'direction 

tieDotted = \property Voice.Tie \set #'dashed = #1
tieSolid = \property Voice.Tie \revert #'dashed


dynamicUp  = {
  \property Voice.DynamicText \set #'direction = #1
  \property Voice.DynamicLineSpanner \set #'direction = #1
}
dynamicDown = {
  \property Voice.DynamicText \set #'direction = #-1
  \property Voice.DynamicLineSpanner \set #'direction = #-1
}
dynamicBoth = {
  \property Voice.DynamicText \revert #'direction
  \property Voice.DynamicLineSpanner \revert #'direction
}

scriptUp  = {
  \property Voice.TextScript \set #'direction = #1
  \property Voice.Script \set #'direction = #1
}
scriptDown = {
  \property Voice.TextScript \set #'direction = #-1
  \property Voice.Script \set #'direction = #-1
}
scriptBoth = {
  \property Voice.TextScript \revert #'direction
  \property Voice.Script \revert #'direction
}

dotsUp = \property Voice.Dots \set #'direction = #1
dotsDown = \property Voice.Dots \set #'direction = #-1
dotsBoth = \property Voice.Dots \revert #'direction 

tupletUp  =   \property Voice.TupletBracket \set #'direction = #1
tupletDown =   \property Voice.TupletBracket \set #'direction = #-1
tupletBoth =   \property Voice.TupletBracket \revert #'direction

cadenzaOn = \property Timing.timing = ##f
cadenzaOff = {
  \property Timing.timing = ##t
  \property Timing.measurePosition = #(ly:make-moment 0 1)
}

newpage = \notes
{
  \break
  % urg, only works for TeX output
  \context Score \applyoutput
  #(outputproperty-compatibility (make-type-checker 'paper-column-interface)
    'between-system-string "\\newpage")
}

% dynamic ly:dir?  text script, articulation script ly:dir?	
oneVoice = #(context-spec-music (make-voice-props-revert) 'Voice)
voiceOne = #(context-spec-music (make-voice-props-set 0) 'Voice)
voiceTwo = #(context-spec-music (make-voice-props-set 1) 'Voice)
voiceThree =#(context-spec-music (make-voice-props-set 2) 'Voice)
voiceFour = #(context-spec-music (make-voice-props-set 3) 'Voice)

	
tiny  = 
	\property Voice.fontSize= #-2

small  = 
	\property Voice.fontSize= #-1

normalsize = {
	\property Voice.fontSize= #0
}


% End the incipit and print a ``normal line start''.
endincipit = \notes \context Staff {
    \partial 16 s16  % Hack to handle e.g. \bar ".|" \endincipit
    \once \property Staff.Clef \set #'full-size-change = ##t
    \once \property Staff.Clef \set #'non-default = ##t
    \bar ""
}

autoBeamOff = \property Voice.autoBeaming = ##f
autoBeamOn = \property Voice.autoBeaming = ##t

fatText = \property Voice.TextScript \set #'no-spacing-rods = ##f
emptyText = \property Voice.TextScript \set #'no-spacing-rods  = ##t

showStaffSwitch = \property Voice.followVoice = ##t
hideStaffSwitch = \property Voice.followVoice = ##f

% accidentals as they were common in the 18th century.
defaultAccidentals = {
  \property Current.extraNatural = ##t
  \property Current.autoAccidentals = #'(Staff (same-octave . 0))
  \property Current.autoCautionaries = #'()
}

% accidentals in voices instead of staves.
% Notice that accidentals from one voice do NOT get cancelled in other voices
voiceAccidentals = {
  \property Current.extraNatural = ##t
  \property Current.autoAccidentals = #'(Voice (same-octave . 0))
  \property Current.autoCautionaries = #'()
  
}

% accidentals as suggested by Kurt Stone, Music Notation in the 20th century.
% This includes all the default accidentals, but accidentals also needs cancelling
% in other octaves and in the next measure.
modernAccidentals = {
  \property Current.extraNatural = ##f
  \property Current.autoAccidentals = #'(Staff (same-octave . 0) (any-octave . 0) (same-octave . 1))
  \property Current.autoCautionaries = #'()  
}

% the accidentals that Stone adds to the old standard as cautionaries
modernCautionaries = {
  \property Current.extraNatural = ##f
  \property Current.autoAccidentals = #'(Staff (same-octave . 0))
  \property Current.autoCautionaries = #'(Staff (any-octave . 0) (same-octave . 1))  
}

% Multivoice accidentals to be read both by musicians playing one voice
% and musicians playing all voices.
% Accidentals are typeset for each voice, but they ARE cancelled across voices.
modernVoiceAccidentals = {
  \property Current.extraNatural = ##f
  \property Current.autoAccidentals = #'(
    Voice (same-octave . 0) (any-octave . 0) (same-octave . 1)
    Staff (same-octave . 0) (any-octave . 0) (same-octave . 1)
  )
  \property Current.autoCautionaries = #'()  
}

% same as modernVoiceAccidental eccept that all special accidentals are typeset
% as cautionaries
modernVoiceCautionaries = {
  \property Current.extraNatural = ##f
  \property Current.autoAccidentals = #'(
    Voice (same-octave . 0) 
  )
  \property Current.autoCautionaries = #'(
    Voice (any-octave . 0) (same-octave . 1)
    Staff (same-octave . 0) (any-octave . 0) (same-octave . 1)
  )  
}

% stone's suggestions for accidentals on grand staff.
% Accidentals are cancelled across the staves in the same grand staff as well
pianoAccidentals = {
  \property Current.autoAccidentals = #'(
    Staff (same-octave . 0) (any-octave . 0) (same-octave . 1)
    GrandStaff (any-octave . 0) (same-octave . 1)
  )
  \property Current.autoCautionaries = #'()  
}

pianoCautionaries = {
  \property Current.autoAccidentals = #'(
    Staff (same-octave . 0)
  )
  \property Current.autoCautionaries = #'(
    Staff (any-octave . 0) (same-octave . 1)
    GrandStaff (any-octave . 0) (same-octave . 1)
  )  
}


% Do not reset the key at the start of a measure.  Accidentals will be
% printed only once and are in effect until overridden, possibly many
% measures later.
noResetKey = {
  \property Current.autoAccidentals = #'(Staff (same-octave . #t))
  \property Current.autoCautionaries = #'()
}

% do not set localKeySignature when a note alterated differently from
% localKeySignature is found.
% Causes accidentals to be printed at every note instead of
% remembered for the duration of a measure.
% accidentals not being remembered, causing accidentals always to be typeset relative to the time signature
forgetAccidentals = {
  \property Current.autoAccidentals = #'(Staff (same-octave . -1))
  \property Current.autoCautionaries = #'()  
}


% To remove a Volta bracket or some other graphical object,
% set it to turnOff. Example: \property Staff.VoltaBracket = \turnOff

%%
%% DO NOT USE THIS. IT CAN LEAD TO CRASHES.
turnOff = #(cons '() '())

% For drawing vertical chord brackets with \arpeggio
% This is a shorthand for the value of the print-function property 
% of either Staff.Arpeggio or PianoStaff.Arpeggio, depending whether 
% cross-staff brackets are desired. 

arpeggioBracket = #Arpeggio::brew_chord_bracket
arpeggio = #(make-music-by-name 'ArpeggioEvent)
glissando = #(make-music-by-name 'GlissandoEvent)

fermataMarkup = \markup { \musicglyph #"scripts-ufermata" } 

setMmRestFermata =
  \once \property Voice.MultiMeasureRestNumber \override #'text =
    #fermataMarkup 


hideNotes =\sequential {
				% hide notes, accidentals, etc.
    \property Voice.Dots \override #'transparent = ##t
    \property Voice.NoteHead \override #'transparent = ##t
    \property Voice.Stem \override #'transparent = ##t
    \property Voice.Beam \override #'transparent = ##t
    \property Staff.Accidental \override #'transparent = ##t
}


unHideNotes =  \sequential {
  \property Staff.Accidental \revert #'transparent
  \property Voice.Beam \revert #'transparent
  \property Voice.Stem \revert #'transparent
  \property Voice.NoteHead \revert #'transparent
  \property Voice.Dots \revert #'transparent 
}

germanChords = {
    \property ChordNames. chordRootNamer = #(chord-name->german-markup #t)
    \property ChordNames. chordNoteNamer = #note-name->german-markup
}
semiGermanChords = {
    \property ChordNames. chordRootNamer = #(chord-name->german-markup #f)
    \property ChordNames. chordNoteNamer = #note-name->german-markup
}
