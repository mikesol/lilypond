#include "clef.hh"

Clef::Clef()
{
    clef_type= "violin";
    c0_pos = -2;
}

void
Clef::read(svec<Scalar>args)
{
    clef_type = args[0];
    if (clef_type == "violin") {
	c0_pos=-2;
    } else if (clef_type == "bass") {
	c0_pos = 10;
    } else
	assert(false);
}
