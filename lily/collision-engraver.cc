/*
  collision-engraver.cc -- implement Collision_engraver

  source file of the GNU LilyPond music typesetter

  (c) 1997--2005 Han-Wen Nienhuys <hanwen@cs.uu.nl>
*/

#include "note-column.hh"
#include "note-collision.hh"

#include "engraver.hh"
#include "axis-group-interface.hh"

class Collision_engraver : public Engraver
{
  Item *col_;
  Link_array<Grob> note_columns_;

protected:
  DECLARE_ACKNOWLEDGER(note_column);
  PRECOMPUTED_VIRTUAL void process_acknowledged ();
  PRECOMPUTED_VIRTUAL void stop_translation_timestep ();
public:
  TRANSLATOR_DECLARATIONS (Collision_engraver);
};

void
Collision_engraver::process_acknowledged ()
{
  if (col_ || note_columns_.size () < 2)
    return;
  if (!col_)
    {
      col_ = make_item ("NoteCollision", SCM_EOL);
    }

  for (int i = 0; i < note_columns_.size (); i++)
    Note_collision_interface::add_column (col_, note_columns_[i]);
}

void
Collision_engraver::acknowledge_note_column (Grob_info i)
{
  if (Note_column::has_interface (i.grob ()))
    {
      /*should check Y axis? */
      if (Note_column::has_rests (i.grob ()) || i.grob ()->get_parent (X_AXIS))
	return;

      note_columns_.push (i.grob ());
    }
}

void
Collision_engraver::stop_translation_timestep ()
{
  col_ = 0;
  note_columns_.clear ();
}

Collision_engraver::Collision_engraver ()
{
  col_ = 0;
}

#include "translator.icc"

ADD_ACKNOWLEDGER(Collision_engraver, note_column);

ADD_TRANSLATOR (Collision_engraver,
		/* descr */ "Collect NoteColumns, and as soon as there are two or more, put them in a NoteCollision object.",
		/* creats*/ "NoteCollision",
		/* accepts */ "",
		/* acks  */ "",
		/* reads */ "",
		/* write */ "");
