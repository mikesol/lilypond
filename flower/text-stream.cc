#include "text-stream.hh"

Text_stream::Text_stream (String fn)
{
  ios::sync_with_stdio();
  if (fn == "")
	    {
	    name = _("<STDIN>");
	    f = stdin;
	      }

	else
	    {
	    name = fn;
	    f = fopen (fn.ch_C (), "r");
	      }

	if (!f)
	  {
	    cerr <<__FUNCTION__<< _(": can't open `") << fn << "'\n";
	    exit (1);
	  }

	line_no = 1;
    }

void
Text_stream::message (String s)
{
  cerr << "\n"<<get_name() << ": " << line ()<<": "<<s<<endl;
}
