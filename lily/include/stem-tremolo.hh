/*   
  stem-tremolo.hh -- declare Abbreviation
  
  source file of the GNU LilyPond music typesetter
  
  (c) 1997--2004 Han-Wen Nienhuys <hanwen@cs.uu.nl>
  
 */

#ifndef ABBREV_HH
#define ABBREV_HH

#include "lily-proto.hh"
#include "lily-guile.hh"

class Stem_tremolo
{
public:
  
  static bool has_interface (Grob*);
  DECLARE_SCHEME_CALLBACK (dim_callback, (SCM smob, SCM axis));
  DECLARE_SCHEME_CALLBACK (print, (SCM ));
  DECLARE_SCHEME_CALLBACK (height, (SCM,SCM));
  static void set_stem (Grob*me, Grob *st);
  static Molecule raw_molecule (Grob*);
};

#endif /* ABBREV_HH */

