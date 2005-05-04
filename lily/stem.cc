/*
  stem.cc -- implement Stem

  source file of the GNU LilyPond music typesetter

  (c) 1996--2005 Han-Wen Nienhuys <hanwen@cs.uu.nl>
  Jan Nieuwenhuizen <janneke@gnu.org>

  TODO: This is way too hairy

  TODO: fix naming.

  Stem-end, chord-start, etc. is all confusing naming.
*/

#include "stem.hh"

#include <math.h>		// rint

#include "lookup.hh"
#include "directional-element-interface.hh"
#include "note-head.hh"
#include "warn.hh"
#include "output-def.hh"
#include "rhythmic-head.hh"
#include "font-interface.hh"
#include "paper-column.hh"
#include "misc.hh"
#include "beam.hh"
#include "rest.hh"
#include "group-interface.hh"
#include "staff-symbol-referencer.hh"
#include "side-position-interface.hh"
#include "dot-column.hh"
#include "stem-tremolo.hh"

void
Stem::set_beaming (Grob *me, int beam_count, Direction d)
{
  SCM pair = me->get_property ("beaming");

  if (!scm_is_pair (pair))
    {
      pair = scm_cons (SCM_EOL, SCM_EOL);
      me->set_property ("beaming", pair);
    }

  SCM lst = index_get_cell (pair, d);
  for (int i = 0; i < beam_count; i++)
    lst = scm_cons (scm_int2num (i), lst);
  index_set_cell (pair, d, lst);
}

int
Stem::get_beaming (Grob *me, Direction d)
{
  SCM pair = me->get_property ("beaming");
  if (!scm_is_pair (pair))
    return 0;

  SCM lst = index_get_cell (pair, d);
  return scm_ilength (lst);
}

Interval
Stem::head_positions (Grob *me)
{
  if (head_count (me))
    {
      Drul_array<Grob *> e (extremal_heads (me));
      return Interval (Staff_symbol_referencer::get_position (e[DOWN]),
		       Staff_symbol_referencer::get_position (e[UP]));
    }
  return Interval ();
}

Real
Stem::chord_start_y (Grob *me)
{
  Interval hp = head_positions (me);
  if (!hp.is_empty ())
    return hp[get_direction (me)] * Staff_symbol_referencer::staff_space (me)
      * 0.5;
  return 0;
}

Real
Stem::stem_end_position (Grob *me)
{
  SCM p = me->get_property ("stem-end-position");
  Real pos;
  if (!scm_is_number (p))
    {
      pos = get_default_stem_end_position (me);
      me->set_property ("stem-end-position", scm_make_real (pos));
    }
  else
    pos = scm_to_double (p);

  return pos;
}

Direction
Stem::get_direction (Grob *me)
{
  Direction d = get_grob_direction (me);

  if (!d)
    {
      d = get_default_dir (me);
      // urg, AAARGH!
      set_grob_direction (me, d);
    }
  return d;
}

void
Stem::set_stemend (Grob *me, Real se)
{
  // todo: margins
  Direction d = get_direction (me);

  if (d && d * head_positions (me)[get_direction (me)] >= se * d)
    me->warning (_ ("weird stem size, check for narrow beams"));

  me->set_property ("stem-end-position", scm_make_real (se));
}

/* Note head that determines hshift for upstems
   WARNING: triggers direction  */
Grob *
Stem::support_head (Grob *me)
{
  if (head_count (me) == 1)
    /* UGH. */
    return unsmob_grob (scm_car (me->get_property ("note-heads")));
  return first_head (me);
}

int
Stem::head_count (Grob *me)
{
  return Pointer_group_interface::count (me, ly_symbol2scm ("note-heads"));
}

/* The note head which forms one end of the stem.
   WARNING: triggers direction  */
Grob *
Stem::first_head (Grob *me)
{
  Direction d = get_direction (me);
  if (d)
    return extremal_heads (me)[-d];
  return 0;
}

/* The note head opposite to the first head.  */
Grob *
Stem::last_head (Grob *me)
{
  Direction d = get_direction (me);
  if (d)
    return extremal_heads (me)[d];
  return 0;
}

/*
  START is part where stem reaches `last' head.

  This function returns a drul with (bottom-head, top-head).
*/
Drul_array<Grob *>
Stem::extremal_heads (Grob *me)
{
  const int inf = 1000000;
  Drul_array<int> extpos;
  extpos[DOWN] = inf;
  extpos[UP] = -inf;

  Drul_array<Grob *> exthead (0, 0);
  for (SCM s = me->get_property ("note-heads"); scm_is_pair (s);
       s = scm_cdr (s))
    {
      Grob *n = unsmob_grob (scm_car (s));
      int p = Staff_symbol_referencer::get_rounded_position (n);

      Direction d = LEFT;
      do
	{
	  if (d * p > d * extpos[d])
	    {
	      exthead[d] = n;
	      extpos[d] = p;
	    }
	}
      while (flip (&d) != DOWN);
    }
  return exthead;
}

static int
integer_compare (int const &a, int const &b)
{
  return a - b;
}

/* The positions, in ascending order.  */
Array<int>
Stem::note_head_positions (Grob *me)
{
  Array<int> ps;
  for (SCM s = me->get_property ("note-heads"); scm_is_pair (s);
       s = scm_cdr (s))
    {
      Grob *n = unsmob_grob (scm_car (s));
      int p = Staff_symbol_referencer::get_rounded_position (n);

      ps.push (p);
    }

  ps.sort (integer_compare);
  return ps;
}

void
Stem::add_head (Grob *me, Grob *n)
{
  n->set_property ("stem", me->self_scm ());
  n->add_dependency (me);

  if (Note_head::has_interface (n))
    Pointer_group_interface::add_grob (me, ly_symbol2scm ("note-heads"), n);
  else if (Rest::has_interface (n))
    Pointer_group_interface::add_grob (me, ly_symbol2scm ("rests"), n);
}

bool
Stem::is_invisible (Grob *me)
{
  Real stemlet_length = robust_scm2double (me->get_property ("stemlet-length"),
					   0.0);

  return !((head_count (me)
	    || stemlet_length > 0.0)
	   && scm_to_int (me->get_property ("duration-log")) >= 1);
}

Direction
Stem::get_default_dir (Grob *me)
{
  int staff_center = 0;
  Interval hp = head_positions (me);
  if (hp.is_empty ())
    return CENTER;

  int udistance = (int) (UP *hp[UP] - staff_center);
  int ddistance = (int) (DOWN *hp[DOWN] - staff_center);

  if (sign (ddistance - udistance))
    return Direction (sign (ddistance - udistance));

  return to_dir (me->get_property ("neutral-direction"));
}

Real
Stem::get_default_stem_end_position (Grob *me)
{
  Real ss = Staff_symbol_referencer::staff_space (me);
  int durlog = duration_log (me);
  SCM s;
  Array<Real> a;

  /* WARNING: IN HALF SPACES */
  Real length = 7;
  SCM scm_len = me->get_property ("length");
  if (scm_is_number (scm_len))
    length = scm_to_double (scm_len);
  else
    {
      s = me->get_property ("lengths");
      if (scm_is_pair (s))
	length = 2 * scm_to_double (robust_list_ref (durlog - 2, s));
    }

  /* URGURGURG
     'set-default-stemlen' sets direction too.   */
  Direction dir = get_direction (me);
  if (!dir)
    {
      dir = get_default_dir (me);
      set_grob_direction (me, dir);
    }

  /* Stems in unnatural (forced) direction should be shortened,
     according to [Roush & Gourlay] */
  Interval hp = head_positions (me);
  if (dir && dir * hp[dir] >= 0)
    {
      SCM sshorten = me->get_property ("stem-shorten");
      SCM scm_shorten = scm_is_pair (sshorten)
	? robust_list_ref (max (duration_log (me) - 2, 0), sshorten) : SCM_EOL;
      Real shorten = 2* robust_scm2double (scm_shorten, 0);

      /* On boundary: shorten only half */
      if (abs (head_positions (me)[dir]) <= 1)
	shorten *= 0.5;

      length -= shorten;
    }

  /* Tremolo stuff.  */
  Grob *t_flag = unsmob_grob (me->get_property ("tremolo-flag"));
  if (t_flag && !unsmob_grob (me->get_property ("beam")))
    {
      /* Crude hack: add extra space if tremolo flag is there.

      We can't do this for the beam, since we get into a loop
      (Stem_tremolo::raw_stencil () looks at the beam.) --hwn  */

      Real minlen = 1.0
	+ 2 * Stem_tremolo::raw_stencil (t_flag).extent (Y_AXIS).length ()
	/ ss;

      if (durlog >= 3)
	{
	  Interval flag_ext = flag (me).extent (Y_AXIS);
	  if (!flag_ext.is_empty ())
	    minlen += 2 * flag_ext.length () / ss;

	  /* The clash is smaller for down stems (since the tremolo is
	     angled up.) */
	  if (dir == DOWN)
	    minlen -= 1.0;
	}
      length = max (length, minlen + 1.0);
    }

  Real st = dir ? hp[dir] + dir * length : 0;

  /* TODO: change name  to extend-stems to staff/center/'()  */
  bool no_extend_b = to_boolean (me->get_property ("no-stem-extend"));
  if (!no_extend_b && dir * st < 0)
    st = 0.0;

  /* Make a little room if we have a upflag and there is a dot.
     previous approach was to lengthen the stem. This is not
     good typesetting practice.  */
  if (!get_beam (me) && dir == UP
      && durlog > 2)
    {
      Grob *closest_to_flag = extremal_heads (me)[dir];
      Grob *dots = closest_to_flag
	? Rhythmic_head::get_dots (closest_to_flag) : 0;

      if (dots)
	{
	  Real dp = Staff_symbol_referencer::get_position (dots);
	  Real flagy = flag (me).extent (Y_AXIS)[-dir] * 2 / ss;

	  /* Very gory: add myself to the X-support of the parent,
	     which should be a dot-column. */
	  if (dir * (st + flagy - dp) < 0.5)
	    {
	      Grob *par = dots->get_parent (X_AXIS);

	      if (Dot_column::has_interface (par))
		{
		  Side_position_interface::add_support (par, me);

		  /* TODO: apply some better logic here. The flag is
		     curved inwards, so this will typically be too
		     much. */
		}
	    }
	}
    }
  return st;
}

/* The log of the duration (Number of hooks on the flag minus two)  */
int
Stem::duration_log (Grob *me)
{
  SCM s = me->get_property ("duration-log");
  return (scm_is_number (s)) ? scm_to_int (s) : 2;
}

void
Stem::position_noteheads (Grob *me)
{
  if (!head_count (me))
    return;

  Link_array<Grob> heads
    = extract_grob_array (me, ly_symbol2scm ("note-heads"));

  heads.sort (compare_position);
  Direction dir = get_direction (me);

  if (dir < 0)
    heads.reverse ();

  Real thick = thickness (me);

  Grob *hed = support_head (me);
  Real w = hed->extent (hed, X_AXIS)[dir];
  for (int i = 0; i < heads.size (); i++)
    heads[i]->translate_axis (w - heads[i]->extent (heads[i], X_AXIS)[dir],
			      X_AXIS);

  bool parity = true;
  Real lastpos = Real (Staff_symbol_referencer::get_position (heads[0]));
  for (int i = 1; i < heads.size (); i++)
    {
      Real p = Staff_symbol_referencer::get_position (heads[i]);
      Real dy = fabs (lastpos- p);

      /*
	dy should always be 0.5, 0.0, 1.0, but provide safety margin
	for rounding errors.
      */
      if (dy < 1.1)
	{
	  if (parity)
	    {
	      Real ell = heads[i]->extent (heads[i], X_AXIS).length ();

	      Direction d = get_direction (me);
	      /*
		Reversed head should be shifted ell-thickness, but this
		looks too crowded, so we only shift ell-0.5*thickness.

		This leads to assymetry: Normal heads overlap the
		stem 100% whereas reversed heads only overlaps the
		stem 50%
	      */

	      Real reverse_overlap = 0.5;
	      heads[i]->translate_axis ((ell - thick * reverse_overlap) * d,
					X_AXIS);

	      if (is_invisible (me))
		heads[i]->translate_axis (-thick * (2 - reverse_overlap) * d,
					  X_AXIS);

	      /* TODO:

	      For some cases we should kern some more: when the
	      distance between the next or prev note is too large, we'd
	      get large white gaps, eg.

	      |
              X|
	      |X  <- kern this.
	      |
	      X

	      */
	    }
	  parity = !parity;
	}
      else
	parity = true;

      lastpos = int (p);
    }
}

MAKE_SCHEME_CALLBACK (Stem, before_line_breaking, 1);
SCM
Stem::before_line_breaking (SCM smob)
{
  Grob *me = unsmob_grob (smob);

  /*
    Do the calculations for visible stems, but also for invisible stems
    with note heads (i.e. half notes.)
  */
  if (head_count (me))
    {
      stem_end_position (me);	// ugh. Trigger direction calc.
      position_noteheads (me);
    }

  return SCM_UNSPECIFIED;
}

/*
  ugh.
  When in a beam with tuplet brackets, brew_mol is called early,
  caching a wrong value.
*/
MAKE_SCHEME_CALLBACK (Stem, height, 2);
SCM
Stem::height (SCM smob, SCM ax)
{
  Axis a = (Axis)scm_to_int (ax);
  Grob *me = unsmob_grob (smob);
  assert (a == Y_AXIS);

  /*
    ugh. - this dependency should be automatic.
  */
  Grob *beam = get_beam (me);
  if (beam)
    {
      Beam::after_line_breaking (beam->self_scm ());
    }

  SCM mol = me->get_uncached_stencil ();
  Interval iv;
  if (mol != SCM_EOL)
    iv = unsmob_stencil (mol)->extent (a);
  if (Grob *b = get_beam (me))
    {
      Direction d = get_direction (me);
      if (d == CENTER)
	{
	  programming_error ("no stem direction");
	  d = UP;
	}
      iv[d] += d * Beam::get_thickness (b) * 0.5;
    }

  return ly_interval2scm (iv);
}

Stencil
Stem::flag (Grob *me)
{
  /* TODO: maybe property stroke-style should take different values,
     e.g. "" (i.e. no stroke), "single" and "double" (currently, it's
     '() or "grace").  */
  String flag_style;

  SCM flag_style_scm = me->get_property ("flag-style");
  if (scm_is_symbol (flag_style_scm))
    flag_style = ly_symbol2string (flag_style_scm);

  if (flag_style == "no-flag")
    return Stencil ();

  bool adjust = true;

  String staffline_offs;
  if (String::compare (flag_style, "mensural") == 0)
    /* Mensural notation: For notes on staff lines, use different
       flags than for notes between staff lines.  The idea is that
       flags are always vertically aligned with the staff lines,
       regardless if the note head is on a staff line or between two
       staff lines.  In other words, the inner end of a flag always
       touches a staff line.
    */
    {
      if (adjust)
	{
	  int p = (int) (rint (stem_end_position (me)));
	  staffline_offs
	    = Staff_symbol_referencer::on_staffline (me, p) ? "0" : "1";
	}
      else
	{
	  staffline_offs = "2";
	}
    }
  else
    {
      staffline_offs = "";
    }

  char dir = (get_direction (me) == UP) ? 'u' : 'd';
  String font_char = flag_style
    + to_string (dir) + staffline_offs + to_string (duration_log (me));
  Font_metric *fm = Font_interface::get_default_font (me);
  Stencil flag = fm->find_by_name ("flags." + font_char);
  if (flag.is_empty ())
    me->warning (_f ("flag `%s' not found", font_char));

  SCM stroke_style_scm = me->get_property ("stroke-style");
  if (scm_is_string (stroke_style_scm))
    {
      String stroke_style = ly_scm2string (stroke_style_scm);
      if (!stroke_style.is_empty ())
	{
	  String font_char = to_string (dir) + stroke_style;
	  Stencil stroke = fm->find_by_name ("flags." + font_char);
	  if (stroke.is_empty ())
	    me->warning (_f ("flag stroke `%s' not found", font_char));
	  else
	    flag.add_stencil (stroke);
	}
    }

  return flag;
}

MAKE_SCHEME_CALLBACK (Stem, width_callback, 2);
SCM
Stem::width_callback (SCM e, SCM ax)
{
  (void) ax;
  assert (scm_to_int (ax) == X_AXIS);
  Grob *me = unsmob_grob (e);

  Interval r;

  if (is_invisible (me))
    {
      r.set_empty ();
    }
  else if (unsmob_grob (me->get_property ("beam")) || abs (duration_log (me)) <= 2)
    {
      r = Interval (-1, 1);
      r *= thickness (me) / 2;
    }
  else
    {
      r = Interval (-1,1) * thickness (me) * 0.5;
      r.unite (flag (me).extent (X_AXIS));
    }
  return ly_interval2scm (r);
}

Real
Stem::thickness (Grob *me)
{
  return scm_to_double (me->get_property ("thickness"))
    * Staff_symbol_referencer::line_thickness (me);
}

MAKE_SCHEME_CALLBACK (Stem, print, 1);
SCM
Stem::print (SCM smob)
{
  Grob *me = unsmob_grob (smob);
  Stencil mol;
  Direction d = get_direction (me);

  Real stemlet_length = robust_scm2double (me->get_property ("stemlet-length"),
					   0.0);
  bool stemlet = stemlet_length > 0.0;

  /* TODO: make the stem start a direction ?
     This is required to avoid stems passing in tablature chords.  */
  Grob *lh
    = to_boolean (me->get_property ("avoid-note-head"))
    ? last_head (me)
    : first_head (me);
  Grob *beam = get_beam (me);

  if (!lh && !stemlet)
    return SCM_EOL;

  if (!lh && stemlet && !beam)
    return SCM_EOL;

  if (is_invisible (me))
    return SCM_EOL;

  Real y2 = stem_end_position (me);
  Real y1 = y2;
  Real half_space = Staff_symbol_referencer::staff_space (me) * 0.5;

  if (lh)
    y2 = Staff_symbol_referencer::get_position (lh);
  else if (stemlet)
    {
      Real beam_translation = Beam::get_beam_translation (beam);
      Real beam_thickness = Beam::get_thickness (beam);
      int beam_count = beam_multiplicity (me).length () + 1;

      y2 -= d
	* (0.5 * beam_thickness
	   + beam_translation * max (0, (beam_count - 1))
	   + stemlet_length) / half_space;
    }

  Interval stem_y (min (y1, y2), max (y2, y1));

  if (Grob *hed = support_head (me))
    {
      /*
	must not take ledgers into account.
      */
      Interval head_height = hed->extent (hed, Y_AXIS);
      Real y_attach = Note_head::stem_attachment_coordinate (hed, Y_AXIS);

      y_attach = head_height.linear_combination (y_attach);
      stem_y[Direction (-d)] += d * y_attach / half_space;
    }

  // URG
  Real stem_width = thickness (me);
  Real blot
    = me->get_layout ()->get_dimension (ly_symbol2scm ("blotdiameter"));

  Box b = Box (Interval (-stem_width / 2, stem_width / 2),
	       Interval (stem_y[DOWN] * half_space, stem_y[UP] * half_space));

  Stencil ss = Lookup::round_filled_box (b, blot);
  mol.add_stencil (ss);

  if (!get_beam (me) && abs (duration_log (me)) > 2)
    {
      Stencil fl = flag (me);
      fl.translate_axis (stem_y[d] * half_space - d * blot / 2, Y_AXIS);
      fl.translate_axis (stem_width / 2, X_AXIS);
      mol.add_stencil (fl);
    }

  return mol.smobbed_copy ();
}

/*
  move the stem to right of the notehead if it is up.
*/
MAKE_SCHEME_CALLBACK (Stem, offset_callback, 2);
SCM
Stem::offset_callback (SCM element_smob, SCM)
{
  Grob *me = unsmob_grob (element_smob);
  Real r = 0.0;

  if (Grob *f = first_head (me))
    {
      Interval head_wid = f->extent (f, X_AXIS);
      Real attach = 0.0;

      if (is_invisible (me))
	attach = 0.0;
      else
	attach = Note_head::stem_attachment_coordinate (f, X_AXIS);

      Direction d = get_direction (me);
      Real real_attach = head_wid.linear_combination (d * attach);
      r = real_attach;

      /* If not centered: correct for stem thickness.  */
      if (attach)
	{
	  Real rule_thick = thickness (me);
	  r += -d * rule_thick * 0.5;
	}
    }
  else
    {
      SCM rests = me->get_property ("rests");
      if (scm_is_pair (rests))
	{
	  Grob *rest = unsmob_grob (scm_car (rests));
	  r = rest->extent (rest, X_AXIS).center ();
	}
    }
  return scm_make_real (r);
}

Spanner *
Stem::get_beam (Grob *me)
{
  SCM b = me->get_property ("beam");
  return dynamic_cast<Spanner *> (unsmob_grob (b));
}

Stem_info
Stem::get_stem_info (Grob *me)
{
  /* Return cached info if available */
  SCM scm_info = me->get_property ("stem-info");
  if (!scm_is_pair (scm_info))
    {
      calc_stem_info (me);
      scm_info = me->get_property ("stem-info");
    }

  Stem_info si;
  si.dir_ = get_grob_direction (me);
  si.ideal_y_ = scm_to_double (scm_car (scm_info));
  si.shortest_y_ = scm_to_double (scm_cadr (scm_info));
  return si;
}

/* TODO: add extra space for tremolos!  */
void
Stem::calc_stem_info (Grob *me)
{
  Direction my_dir = get_grob_direction (me);

  if (!my_dir)
    {
      programming_error ("no stem dir set");
      my_dir = UP;
    }

  Real staff_space = Staff_symbol_referencer::staff_space (me);
  Grob *beam = get_beam (me);
  Real beam_translation = Beam::get_beam_translation (beam);
  Real beam_thickness = Beam::get_thickness (beam);
  int beam_count = Beam::get_direction_beam_count (beam, my_dir);

  /* Simple standard stem length */
  SCM lengths = me->get_property ("beamed-lengths");
  Real ideal_length
    = scm_to_double (robust_list_ref (beam_count - 1, lengths))

    * staff_space
    /* stem only extends to center of beam
     */
    - 0.5 * beam_thickness;

  /* Condition: sane minimum free stem length (chord to beams) */
  lengths = me->get_property ("beamed-minimum-free-lengths");
  Real ideal_minimum_free
    = scm_to_double (robust_list_ref (beam_count - 1, lengths))
    * staff_space;

  /* UGH
     It seems that also for ideal minimum length, we must use
     the maximum beam count (for this direction):

     \score{ \notes\relative c''{ [a8 a32] }}

     must be horizontal. */
  Real height_of_my_beams = beam_thickness
    + (beam_count - 1) * beam_translation;

  Real ideal_minimum_length = ideal_minimum_free
    + height_of_my_beams
    /* stem only extends to center of beam */
    - 0.5 * beam_thickness;

  ideal_length = max (ideal_length, ideal_minimum_length);

  /* Convert to Y position, calculate for dir == UP */
  Real note_start
    =     /* staff positions */
    head_positions (me)[my_dir] * 0.5
    * my_dir * staff_space;
  Real ideal_y = note_start + ideal_length;

  /* Conditions for Y position */

  /* Lowest beam of (UP) beam must never be lower than second staffline

  Reference?

  Although this (additional) rule is probably correct,
  I expect that highest beam (UP) should also never be lower
  than middle staffline, just as normal stems.

  Reference?

  Obviously not for grace beams.

  Also, not for knees.  Seems to be a good thing. */
  bool no_extend_b = to_boolean (me->get_property ("no-stem-extend"));
  bool is_knee = to_boolean (beam->get_property ("knee"));
  if (!no_extend_b && !is_knee)
    {
      /* Highest beam of (UP) beam must never be lower than middle
	 staffline */
      ideal_y = max (ideal_y, 0.0);
      /* Lowest beam of (UP) beam must never be lower than second staffline */
      ideal_y = max (ideal_y, (-staff_space
			       - beam_thickness + height_of_my_beams));
    }

  ideal_y -= robust_scm2double (beam->get_property ("shorten"), 0);

  Real minimum_free
    = scm_to_double (robust_list_ref
		     (beam_count - 1,
		      me->get_property
		      ("beamed-extreme-minimum-free-lengths")))
    * staff_space;

  Real minimum_length = minimum_free
    + height_of_my_beams
    /* stem only extends to center of beam */
    - 0.5 * beam_thickness;

  if (Grob *tremolo = unsmob_grob (me->get_property ("tremolo-flag")))
    {
      Interval y_ext = tremolo->extent (tremolo, Y_AXIS);
      y_ext.widen (0.5);	// FIXME. Should be tunable? 
      minimum_length = max (minimum_length, y_ext.length ());
    }
  
  ideal_y *= my_dir;
  Real minimum_y = note_start + minimum_length;
  Real shortest_y = minimum_y * my_dir;

  me->set_property ("stem-info",
		    scm_list_2 (scm_make_real (ideal_y),
				scm_make_real (shortest_y)));
}

Slice
Stem::beam_multiplicity (Grob *stem)
{
  SCM beaming = stem->get_property ("beaming");
  Slice le = int_list_to_slice (scm_car (beaming));
  Slice ri = int_list_to_slice (scm_cdr (beaming));
  le.unite (ri);
  return le;
}

/* FIXME:  Too many properties  */
ADD_INTERFACE (Stem, "stem-interface",
	       "The stem represent the graphical stem.  "
	       "In addition, it internally connects note heads, beams and"
	       "tremolos. "
	       "Rests and whole notes have invisible stems.",
	       "tremolo-flag french-beaming "
	       "avoid-note-head thickness "
	       "stemlet-length rests "
	       "stem-info beamed-lengths beamed-minimum-free-lengths "
	       "beamed-extreme-minimum-free-lengths lengths beam stem-shorten "
	       "duration-log beaming neutral-direction stem-end-position "
	       "note-heads direction length flag-style "
	       "no-stem-extend stroke-style");

/****************************************************************/

Stem_info::Stem_info ()
{
  ideal_y_ = shortest_y_ = 0;
  dir_ = CENTER;
}

void
Stem_info::scale (Real x)
{
  ideal_y_ *= x;
  shortest_y_ *= x;
}
