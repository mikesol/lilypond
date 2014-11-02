%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.di.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.18.0"

\header {
  lsrtags = "breaks, staff-notation, tweaks-and-overrides"

  texidoc = "
The first empty staff can also be removed from the score by setting the
@code{VerticalAxisGroup} property @code{remove-first}. This can be done
globally inside the @code{\\layout} block, or locally inside the
specific staff that should be removed.  In the latter case, you have to
specify the context (@code{Staff} applies only to the current staff) in
front of the property.

The lower staff of the second staff group is not removed, because the
setting applies only to the specific staff inside of which it is
written.

"
  doctitle = "Removing the first empty line"
} % begin verbatim

\layout {
  \context {
    \Staff \RemoveEmptyStaves
    % To use the setting globally, uncomment the following line:
    % \override VerticalAxisGroup.remove-first = ##t
  }
}
\new StaffGroup <<
  \new Staff \relative c' {
    e4 f g a \break
    c1
  }
  \new Staff {
    % To use the setting globally, comment this line,
    % uncomment the line in the \layout block above
    \override Staff.VerticalAxisGroup.remove-first = ##t
    R1 \break
    R
  }
>>
\new StaffGroup <<
  \new Staff \relative c' {
    e4 f g a \break
    c1
  }
  \new Staff {
    R1 \break
    R
  }
>>
