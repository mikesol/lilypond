;;;; framework-tex.scm --
;;;;
;;;;  source file of the GNU LilyPond music typesetter
;;;;
;;;; (c)  2004 Han-Wen Nienhuys <hanwen@cs.uu.nl>

(define-module (scm framework-tex)
  #:export (output-framework-tex	    
	    output-classic-framework-tex
))

(use-modules (ice-9 regex)
	     (ice-9 string-fun)
	     (ice-9 format)
	     (guile)
	     (srfi srfi-13)
	     (lily))

(define-public (sanitize-tex-string s) ;; todo: rename
   (if (ly:get-option 'safe)
      (regexp-substitute/global #f "\\\\"
				(regexp-substitute/global #f "([{}])" "bla{}" 'pre  "\\" 1 'post )
				'pre "$\\backslash$" 'post)
      
      s))

(define (symbol->tex-key sym)
  (regexp-substitute/global
   #f "_" (sanitize-tex-string (symbol->string sym)) 'pre "X" 'post) )

(define (tex-number-def prefix key number)
  (string-append
   "\\def\\" prefix (symbol->tex-key key) "{" number "}%\n"))

(define-public (tex-font-command font)
  (string-append
   "magfont"
   (string-encode-integer
    (hashq (ly:font-filename font) 1000000))
   "m"
   (string-encode-integer
    (inexact->exact (round (* 1000 (ly:font-magnification font)))))))

(define (font-load-command bookpaper font)
  (string-append
   "\\font\\" (tex-font-command font) "="
   (ly:font-filename font)
   " scaled "
   (ly:number->string (inexact->exact
		       (round (* 1000
			  (ly:font-magnification font)
			  (ly:bookpaper-outputscale bookpaper)))))
   "\n"))


(define (define-fonts bookpaper)
  (string-append
   "\\def\\lilypondpaperunit{mm}" ;; UGH. FIXME.
   (tex-number-def "lilypondpaper" 'outputscale
		   (number->string (exact->inexact
				    (ly:bookpaper-outputscale bookpaper))))
   (tex-string-def "lilypondpapersize" 'papersize
		   (eval 'papersize (ly:output-def-scope bookpaper)))

   (apply string-append
	  (map (lambda (x) (font-load-command bookpaper x))
	       (ly:bookpaper-fonts bookpaper)))))

(define (header-to-file fn key val)
  (set! key (symbol->string key))
  (if (not (equal? "-" fn))
      (set! fn (string-append fn "." key)))
  (display
   (format "Writing header field `~a' to `~a'..."
	   key
	   (if (equal? "-" fn) "<stdout>" fn)
	   )
   (current-error-port))
  (if (equal? fn "-")
      (display val)
      (display val (open-file fn "w")))
  (display "\n" (current-error-port))
  "")

(define (output-scopes  scopes fields basename)
  (define (output-scope scope)
    (apply
     string-append
     (module-map
      (lambda (sym var)
	(let ((val (if (variable-bound? var) (variable-ref var) ""))
	      )
	  
	  (if (and (memq sym fields) (string? val))
	      (header-to-file basename sym val))
	  ""))
      scope)))
  (apply string-append (map output-scope scopes)))

(define (tex-string-def prefix key str)
  (if (equal? "" (sans-surrounding-whitespace (sanitize-tex-string str)))
      (string-append "\\let\\" prefix (symbol->tex-key key) "\\undefined%\n")
      (string-append "\\def\\" prefix (symbol->tex-key key)
		     "{" (sanitize-tex-string str) "}%\n")))

(define (header creator time-stamp bookpaper page-count classic?)
  (let ((scale (ly:output-def-lookup bookpaper 'outputscale)))

    (string-append
     "% Generated by " creator "\n"
     "% at " time-stamp "\n"
     (if classic?
	 (tex-string-def "lilypond" 'classic "1")
	 "")

     (tex-string-def
      "lilypondpaper" 'linewidth
      (ly:number->string (* scale (ly:output-def-lookup bookpaper 'linewidth))))

     (tex-string-def
      "lilypondpaper" 'interscoreline
      (ly:number->string
       (* scale (ly:output-def-lookup bookpaper 'interscoreline)))))))

(define (header-end)
  (string-append
   "\\def\\scaletounit{ "
   (number->string (cond
		    ((equal? (ly:unit) "mm") (/ 72.0 25.4))
		    ((equal? (ly:unit) "pt") (/ 72.0 72.27))
		    (else (error "unknown unit" (ly:unit)))))
   " mul }%\n"
   "\\ifx\\lilypondstart\\undefined\n"
   "  \\input lilyponddefs\n"
   "\\fi\n"
   "\\outputscale = \\lilypondpaperoutputscale\\lilypondpaperunit\n"
   "\\lilypondstart\n"
   "\\lilypondspecial\n"
   "\\lilypondpostscript\n"))

(define (dump-page putter page last?)
  (ly:outputter-dump-string
   putter
   "\n\\vbox to 0pt{%\n\\leavevmode\n\\lybox{0}{0}{0}{0}{%\n")
  (ly:outputter-dump-stencil putter page)
  (ly:outputter-dump-string
   putter
   (if last?
       "}\\vss\n}\n\\vfill\n"
       "}\\vss\n}\n\\vfill\\lilypondpagebreak\n")))

(define-public (output-framework-tex outputter book scopes fields basename)
  (let* ((bookpaper (ly:paper-book-book-paper book))
	 (pages (ly:paper-book-pages book))
	 (last-page (car (last-pair pages)))
	 )
    (for-each
     (lambda (x)
       (ly:outputter-dump-string outputter x))
     (list
      (header "creator" "timestamp" bookpaper (length pages) #f)
      (define-fonts bookpaper)
      (header-end)))
    
    (for-each
     (lambda (page) (dump-page outputter page (eq? last-page page)))
     pages)
    (ly:outputter-dump-string outputter "\\lilypondend\n")))

(define (dump-line putter line last?)
  (ly:outputter-dump-string
   putter
   (string-append "\\leavevmode\n\\lybox{0}{0}{0}{"
		  (ly:number->string (ly:paper-line-extent line Y))
		  "}{"))

  (ly:outputter-dump-stencil putter (ly:paper-line-stencil line))
  (ly:outputter-dump-string
   putter
   (if last?
       "}%\n"
       "}\\interscoreline\n")))

(define-public (output-classic-framework-tex
		outputter book scopes fields basename)
  (let* ((bookpaper (ly:paper-book-book-paper book))
	 (lines (ly:paper-book-lines book))
	 (last-line (car (last-pair lines))))
    (for-each
     (lambda (x)
       (ly:outputter-dump-string outputter x))
     (list
      ;;FIXME
      (header "creator" "timestamp" bookpaper (length lines) #f)
      "\\def\\lilypondclassic{1}%\n"
      (output-scopes scopes fields basename)
      (define-fonts bookpaper)
      (header-end)))

    (for-each
     (lambda (line) (dump-line outputter line (eq? line last-line))) lines)
    (ly:outputter-dump-string outputter "\\lilypondend\n")))

