/*
  break-align-item.hh -- declare Break_align_item

  source file of the GNU LilyPond music typesetter

  (c) 1997 Han-Wen Nienhuys <hanwen@stack.nl>
*/


#ifndef BREAK_ALIGN_ITEM_HH
#define BREAK_ALIGN_ITEM_HH

#include "horizontal-align-item.hh"

/// align breakable items (clef, bar, etc.)
class Break_align_item : public Horizontal_align_item {

protected:
    virtual void do_pre_processing();
public:
    NAME_MEMBERS();
    SCORE_ELEM_CLONE(Break_align_item);
	
};
#endif // BREAK_ALIGN_ITEM_HH
