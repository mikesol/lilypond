\version "2.17.18"

\header {
  lsrtags = "pitches, staff-notation, tweaks-and-overrides"

  texidoc = "
Changing the Clef glyph, its position, or the ottavation does not
change the position of subsequent notes on the staff.  To get key
signatures on their correct staff lines @code{middleCClefPosition}
must also be specified, with positive or negative values moving
@emph{middle C} up or down respectively, relative to the staff's
center line.

For example, @code{\\clef \"treble_8\"} is equivalent to setting
the @code{clefGlyph}, @code{clefPosition} (the vertical position
of the clef itself on the staff), @code{middleCPosition} and
@code{clefTransposition}. Note that when any of these properties
(except @code{middleCPosition}) are changed a new clef symbol is
printed.

The following examples show the possibilities when setting these
properties manually. On the first line, the manual changes preserve the
standard relative positioning of clefs and notes, whereas on the second
line, they do not.

"
  doctitle = "Tweaking clef properties"
} % begin verbatim

\layout { ragged-right = ##t }
{
  % The default treble clef
  \key f \major
  c'1
  % The standard bass clef
  \set Staff.clefGlyph = #"clefs.F"
  \set Staff.clefPosition = #2
  \set Staff.middleCPosition = #6
  \set Staff.middleCClefPosition = #6
  \key g \major
  c'1
  % The baritone clef
  \set Staff.clefGlyph = #"clefs.C"
  \set Staff.clefPosition = #4
  \set Staff.middleCPosition = #4
  \set Staff.middleCClefPosition = #4
  \key f \major
  c'1
  % The standard choral tenor clef
  \set Staff.clefGlyph = #"clefs.G"
  \set Staff.clefPosition = #-2
  \set Staff.clefTransposition = #-7
  \set Staff.middleCPosition = #1
  \set Staff.middleCClefPosition = #1
  \key f \major
  c'1
  % A non-standard clef
  \set Staff.clefPosition = #0
  \set Staff.clefTransposition = #0
  \set Staff.middleCPosition = #-4
  \set Staff.middleCClefPosition = #-4
  \key g \major
  c'1 \break

  % The following clef changes do not preserve
  % the normal relationship between notes, key signatures
  % and clefs:

  \set Staff.clefGlyph = #"clefs.F"
  \set Staff.clefPosition = #2
  c'1
  \set Staff.clefGlyph = #"clefs.G"
  c'1
  \set Staff.clefGlyph = #"clefs.C"
  c'1
  \set Staff.clefTransposition = #7
  c'1
  \set Staff.clefTransposition = #0
  \set Staff.clefPosition = #0
  c'1

  % Return to the normal clef:

  \set Staff.middleCPosition = #0
  c'1
}
