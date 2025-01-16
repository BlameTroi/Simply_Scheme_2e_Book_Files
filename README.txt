		     ===========================
			 Supporting Files for
			    Simply Scheme:
		     Introducing Computer Science
				 2/e
			Copyright (C) 1999 MIT
		     ===========================

These directories hold supporting files for the textbook...

Harvey, B., & Wright, M. (1999). Simply Scheme: Introducing Computer
Science (2ND ed.). MIT. (https://people.eecs.berkeley.edu/~bh/ss-toc2.html)

...as downloaded mid January 2025.

Anyone wanting to work through the text needs to load `simply.scm'
into their Scheme system. The other files are recommenced in the
appendix and are found in various chapters throughout the text.

The text is still in copyright and still available to purchase, but
Harvey offers the text online for personal use. The original license
from the text is in `COPYLEFT.txt', my licensing can be found in
`LICENSE' and `MIT-LICENSE' for any derivative work I do.

To boil it down, their license is an early GPL. Anything I write I
consider public domain but for those who require a more explicit
license, you can choose between the UNLICENSE and the MIT License.

Directory structure and files:

Simply_Scheme_2e_Book_Files
├── COPYLEFT.txt
├── LICENSE
├── MIT-LICENSE
├── README.txt
├── database.scm
├── functions.scm
├── match.scm
├── originals
│   ├── database.scm
│   ├── functions.scm
│   ├── match.scm
│   ├── simply.scm
│   ├── spread.scm
│   └── ttt.scm
├── simply.scm
├── spread.scm
└── ttt.scm

2 directories, 16 files

I suspect that as I learn more I'll build a site specific module for
my Scheme(s). I'm currently using Guile but will shift to Chez Scheme
if needed. Loading the `simply.scm' file from either ~/.guile or
during Emacs/Geiser initialization is needed to work through the text.

2025-01-09 -- using simply2.scm in place of simply.scm. I found it
              on another site for the text and it is formatted more
              clearly, and had one reordering of a (let ()).

2025-01-09 -- doing the testing for compatibility quirks, the random
              in simply.scm has been removed, Guile 3 has random.

	      The definition of error-print form has been simplified
	      to return quotes as expected.

	      Guile's line reading behavior is "wrong" and so the
	      call to read-line at the start of functions.scm is
	      not needed. It was already commented out in the
	      copy I downloaded.

	      Finally, it appears that Guile is not allowing the
	      redefinition of some primitives (+ -, etc). I have
	      yet to determine how much of a problem this is.

	      Chez doesn't either. Racket supplies it's own
	      language definition (? not sure of terminology)
	      for simply.scm, so I can use it in the REPL.

2025-01-10 -- Thanks to help from the r/scheme community, I have
	      more options. Chicken Scheme works and provides better
	      diagnostics than Racket while providing a minimalist
	      environment. Just what I was looking for.

	      Other advice was to check any R5RS Scheme. I'd seen
	      mentions of the various standards and levels of
	      compliance, but checking for the existent standard
	      in 1999 never occurred to me. In the toolbox!
	      
Troy Brumley, blametroi@gmail.com, January 2025.

So let it be written,
So let it be done.

