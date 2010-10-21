\version "2.13.36"

\header {
  lsrtags = "tweaks-and-overrides"

  texidoc = "
Some grobs can be accessed @qq{laterally} from within another grob's
callback.  These are usually listed as @qq{layout objects} in the
@qq{Internal properties} section of a grob-interface.  The function
@code{ly:grob-object} is used to access these grobs.


Demonstrated below are some ways of accessing grobs from within a
NoteHead callback, but the technique is not limited to NoteHeads.
However, the NoteHead callback is particularly important, since it is
the implicit callback used by the @code{\\tweak} command.


The example function defined below (\"display-grobs\") is probably not
that useful, but it demonstrates that the grobs are indeed being
accessed.


Example console output:


@example
--------------------
#-Grob Accidental -
#-Grob Arpeggio -
#-Grob Stem -
@end example


"
  doctitle = "Using ly:grob-object to access grobs with \\tweak"
}

#(define (notehead-get-accidental notehead)
   ;; notehead is grob
   (ly:grob-object notehead 'accidental-grob))

#(define (notehead-get-arpeggio notehead)
   ;; notehead is grob
   (let ((notecolumn (notehead-get-notecolumn notehead)))
     (ly:grob-object notecolumn 'arpeggio)))

#(define (notehead-get-notecolumn notehead)
   ;; notehead is grob
   (ly:grob-parent notehead X))

#(define (notehead-get-stem notehead)
   ;; notehead is grob
   (let ((notecolumn (notehead-get-notecolumn notehead)))
     (ly:grob-object notecolumn 'stem)))

#(define (display-grobs notehead)
   ;; notehead is grob
   (let ((accidental (notehead-get-accidental notehead))
         (arpeggio (notehead-get-arpeggio notehead))
         (stem (notehead-get-stem notehead)))
     (format #t "~2&~a\n" (make-string 20 #\-))
     (for-each
      (lambda (x) (format #t "~a\n" x))
      (list accidental arpeggio stem))))

\relative c' {
  %% display grobs for each note head:
  %\override NoteHead #'before-line-breaking = #display-grobs
  <c
  %% or just for one:
  \tweak #'before-line-breaking #display-grobs
  es
  g>1\arpeggio
}
