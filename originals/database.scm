Project: A Database Program

;; TODO: split program and text (Org?)


From Simply Scheme.

A database is a large file with lots of related data in it. For example, you might have a database of your local Chinese restaurants, listing their names, their addresses, and how good their potstickers are, like this:[0]

Name:           Address:                  City:           Potstickers:

Cal's           1866 Euclid               Berkeley        nondescript
Hunan           924 Sansome               San Francisco   none
Mary Chung's    464 Massachusetts Avenue  Cambridge       great
Shin Shin       1715 Solano Avenue        Berkeley        awesome
TC Garden       2507 Hearst Avenue        Berkeley        doughy
Yet Wah         2140 Clement              San Francisco   fantastic
There are six records in this database, one for each restaurant. Each record contains four pieces of information; we say that the database has four fields.

A database program is a program that can create, store, modify, and examine databases. At the very least, a database program must let you create new databases, enter records, and save the database to a file. More sophisticated operations involve sorting the records in a database by a particular field, printing out the contents of the database, counting the number of records that satisfy a certain condition, taking statistics such as averages, and so on.

There are many commercial database programs available; our version will have some of the flavor of more sophisticated programs while leaving out a lot of the details.

A Sample Session with Our Database

Most database programs come with their own programming language built in. Our database program will use Scheme itself as the language; you will be able to perform database commands by invoking Scheme procedures at the Scheme prompt. Here is a sample session with our program:

> (load "database.scm")
#F
> (new-db "albums" '(artist title year brian-likes?))
CREATED
First we loaded the database program, then we created a new database called "albums"[1] with four fields.[2] Let's enter some data:

> (insert)
Value for ARTIST--> (the beatles)
Value for TITLE--> "A Hard Day's Night"
Value for YEAR--> 1964
Value for BRIAN-LIKES?--> #t
Insert another? yes
Value for ARTIST--> (the zombies)
Value for TITLE--> "Odessey and Oracle"
Value for YEAR--> 1967
Value for BRIAN-LIKES?--> #t
Insert another? y
Value for ARTIST--> (frank zappa)
Value for TITLE--> "Hot Rats"
Value for YEAR--> 1970
Value for BRIAN-LIKES?--> #f
Insert another? y
Value for ARTIST--> (the beatles)
Value for TITLE--> "Rubber Soul"
Value for YEAR--> 1965
Value for BRIAN-LIKES?--> #t
Insert another? no
INSERTED
(We used strings for the album titles but sentences for the artists, partly because one of the titles has an apostrophe in it, but mainly just to demonstrate that fields can contain any data type.)

At this point we start demonstrating features that aren't actually in the version of the program that we've provided. You will implement these features in this project. We're showing them now as if the project were finished to convey the overall flavor of how the program should work.

We can print out the information in a database, and count the number of records:[3]

> (list-db)
RECORD 1
ARTIST: (THE BEATLES)
TITLE: Rubber Soul
YEAR: 1965
BRIAN-LIKES?: #T

RECORD 2
ARTIST: (FRANK ZAPPA)
TITLE: Hot Rats
YEAR: 1970
BRIAN-LIKES?: #F

RECORD 3
ARTIST: (THE ZOMBIES)
TITLE: Odessey and Oracle
YEAR: 1967
BRIAN-LIKES?: #T

RECORD 4
ARTIST: (THE BEATLES)
TITLE: A Hard Day's Night
YEAR: 1964
BRIAN-LIKES?: #T

LISTED
> (count-db)
4
We can insert new records into the database later on:

> (insert)
Value for ARTIST--> (the bill frisell band)
Value for TITLE--> "Where in the World?"
Value for YEAR--> 1991
Value for BRIAN-LIKES?--> #f
Insert another? no
INSERTED
We can sort the records of the database, basing the sorting order on a particular field:

> (sort-on 'year)
YEAR

> (list-db)
RECORD 1
ARTIST: (THE BEATLES)
TITLE: A Hard Day's Night
YEAR: 1964
BRIAN-LIKES?: #T

RECORD 2
ARTIST: (THE BEATLES)
TITLE: Rubber Soul
YEAR: 1965
BRIAN-LIKES?: #T

RECORD 3
ARTIST: (THE ZOMBIES)
TITLE: Odessey and Oracle
YEAR: 1967
BRIAN-LIKES?: #T

RECORD 4
ARTIST: (FRANK ZAPPA)
TITLE: Hot Rats
YEAR: 1970
BRIAN-LIKES?: #F

RECORD 5
ARTIST: (THE BILL FRISELL BAND)
TITLE: Where in the World?
YEAR: 1991
BRIAN-LIKES?: #F

LISTED
We can change the information in a record:

> (edit-record 1)
ARTIST: (THE BEATLES)
TITLE: A Hard Day's Night
YEAR: 1964
BRIAN-LIKES?: #T

Edit which field?  title
New value for TITLE--> "A Hard Day's Night (original soundtrack)"
ARTIST: (THE BEATLES)
TITLE: A Hard Day's Night (original soundtrack)
YEAR: 1964
BRIAN-LIKES?: #T

Edit which field?  #f
EDITED
(The edit-record procedure takes a record number as its argument. In this case, we wanted the first record. Also, the way you stop editing a record is by entering #f as the field name.)

Finally, we can save a database to a file and retrieve it later:

> (save-db)
SAVED

> (load-db "albums")
LOADED
How Databases Are Stored Internally

Our program will store a database as a vector of three elements: the file name associated with the database, a list of the names of the fields of the database, and a list of records in the database.

Each record of the database is itself a vector, containing values for the various fields. (So the length of a record vector depends on the number of fields in the database.)

Why is each record a vector, but the collection of records a list? Records have to be vectors because they are mutable; the edit command lets you change the value of a field for a record. But there is no command to replace an entire record with a new one, so the list of records doesn't have to be mutable.

An advantage of storing the records in a list instead of a vector is that it's easy to insert new records. If you've got a new record and a list of the old records, you simply cons the new record onto the old ones, and that's the new list. You need to mutate the vector that represents the entire database to contain this new list instead of the old one, but you don't need to mutate the list itself.

Here's the albums database we created, as it looks to Scheme:

#("albums"
  (ARTIST TITLE YEAR BRIAN-LIKES?)
  (#((THE BEATLES) "A Hard Day's Night (original soundtrack)" 1964 #T)
   #((THE BEATLES) "Rubber Soul" 1965 #T)
   #((THE ZOMBIES) "Odessey and Oracle" 1967 #T)
   #((FRANK ZAPPA) "Hot Rats" 1970 #F)
   #((THE BILL FRISELL BAND) "Where in the World?" 1991 #F)))
We'll treat databases as an abstract data type; here is how we implement it:

;;; The database ADT: a filename, list of fields and list of records

(define (make-db filename fields records)
  (vector filename fields records))

(define (db-filename db)
  (vector-ref db 0))

(define (db-set-filename! db filename)
  (vector-set! db 0 filename))

(define (db-fields db)
  (vector-ref db 1))

(define (db-set-fields! db fields)
  (vector-set! db 1 fields))

(define (db-records db)
  (vector-ref db 2))

(define (db-set-records! db records)
  (vector-set! db 2 records))
The Current Database

The database program works on one database at a time. Every command implicitly refers to the current database. Since the program might switch to a new database, it has to keep the current database in a vector that it can mutate if necessary. For now, the current database is the only state information that the program keeps, so it's stored in a vector of length one. If there is no current database (for example, when you start the database program), the value #f is stored in this vector:

(define current-state (vector #f))

(define (no-db?)
  (not (vector-ref current-state 0)))

(define (current-db)
  (if (no-db?)
      (error "No current database!")
      (vector-ref current-state 0)))

(define (set-current-db! db)
  (vector-set! current-state 0 db))

(define (current-fields)
  (db-fields (current-db)))
Implementing the Database Program Commands

Once we have the basic structure of the database program, the work consists of inventing the various database operations. Here is the new-db procedure:

(define (new-db filename fields)
  (set-current-db! (make-db filename fields '()))
  'created)
(Remember that when you first create a database there are no records in it.)

Here's the insert procedure:

(define (insert)
  (let ((new-record (get-record)))
    (db-insert new-record (current-db)))
  (if (ask "Insert another? ")
      (insert)
      'inserted))

(define (db-insert record db)
  (db-set-records! db (cons record (db-records db))))

(define (get-record)
  (get-record-loop 0
		   (make-vector (length (current-fields)))
		   (current-fields)))

(define (get-record-loop which-field record fields)
  (if (null? fields)
      record
      (begin (display "Value for ")
	     (display (car fields))
	     (display "--> ")
	     (vector-set! record which-field (read))
	     (get-record-loop (+ which-field 1) record (cdr fields)))))

(define (ask question)
  (display question)
  (let ((answer (read)))
    (cond ((equal? (first answer) 'y) #t)
	  ((equal? (first answer) 'n) #f)
	  (else (show "Please type Y or N.")
		(ask question)))))
Additions to the Program

The database program we've shown so far has the structure of a more sophisticated program, but it's missing almost every feature you'd want it to have. Some of the following additions are ones that we've demonstrated, but for which we haven't provided an implementation; others are introduced here for the first time.

In all of these additions, think about possible error conditions and how to handle them. Try to find a balance between failing even on errors that are very likely to occur and having an entirely safe program that has more error checking than actual content.

Count-db

Implement the count-db procedure. It should take no arguments, and it should return the number of records in the current database.

List-db

Implement the list-db procedure. It should take no arguments, and it should print the current database in the format shown earlier.

Edit-record

Implement edit-record, which takes a number between one and the number of records in the current database as its argument. It should allow the user to interactively edit the given record of the current database, as shown earlier.

Save-db and Load-db

Write save-db and load-db. Save-db should take no arguments and should save the current database into a file with the name that was given when the database was created. Make sure to save the field names as well as the information in the records.

Load-db should take one argument, the filename of the database you want to load. It should replace the current database with the one in the specified file. (Needless to say, it should expect files to be in the format that save-db creates.)

In order to save information to a file in a form that Scheme will be able to read back later, you will need to use the write procedure instead of display or show, as discussed in Chapter 22.

Clear-current-db!

The new-db and load-db procedures change the current database. New-db creates a new, blank database, while load-db reads in an old database from a file. In both cases, the program just throws out the current database. If you forgot to save it, you could lose a lot of work.

Write a procedure clear-current-db! that clears the current database. If there is no current database, clear-current-db! should do nothing. Otherwise, it should ask the user whether to save the database, and if so it should call save-db.

Modify new-db and load-db to invoke clear-current-db!.

Get

Many of the kinds of things that you would want to do to a database involve looking up the information in a record by the field name. For example, the user might want to list only the artists and titles of the album database, or sort it by year, or list only the albums that Brian likes.

But this isn't totally straightforward, since a record doesn't contain any information about names of fields. It doesn't make sense to ask what value the price field has in the record

#(SPROCKET 15 23 17 2)
without knowing the names of the fields of the current database and their order.

Write a procedure get that takes two arguments, a field name and a record, and returns the given field of the given record. It should work by looking up the field name in the list of field names of the current database.

> (get 'title '#((the zombies) "Odessey and Oracle" 1967 #t))
"Odessey and Oracle"
Get can be thought of as a selector for the record data type. To continue the implementation of a record ADT, write a constructor blank-record that takes no arguments and returns a record with no values in its fields. (Why doesn't blank-record need any arguments?) Finally, write the mutator record-set! that takes three arguments: a field name, a record, and a new value for the corresponding field.

Modify the rest of the database program to use this ADT instead of directly manipulating the records as vectors.

Sort

Write a sort command that takes a predicate as its argument and sorts the database according to that predicate. The predicate should take two records as arguments and return #t if the first record belongs before the second one, or #f otherwise. Here's an example:

> (sort (lambda (r1 r2) (before? (get 'title r1) (get 'title r2))))
SORTED

> (list-db)
RECORD 1
ARTIST: (THE BEATLES)
TITLE: A Hard Day's Night (original soundtrack)
YEAR: 1964
BRIAN-LIKES?: #T

RECORD 2
ARTIST: (FRANK ZAPPA)
TITLE: Hot Rats
YEAR: 1970
BRIAN-LIKES?: #F

RECORD 3
ARTIST: (THE ZOMBIES)
TITLE: Odessey and Oracle
YEAR: 1967
BRIAN-LIKES?: #T

RECORD 4
ARTIST: (THE BEATLES)
TITLE: Rubber Soul
YEAR: 1965
BRIAN-LIKES?: #T

RECORD 5
ARTIST: (THE BILL FRISELL BAND)
TITLE: Where in the World?
YEAR: 1991
BRIAN-LIKES?: #F

LISTED

> (sort (lambda (r1 r2) (< (get 'year r1) (get 'year r2))))
SORTED

> (list-db)
RECORD 1
ARTIST: (THE BEATLES)
TITLE: A Hard Day's Night (original soundtrack)
YEAR: 1964
BRIAN-LIKES?: #T

RECORD 2
ARTIST: (THE BEATLES)
TITLE: Rubber Soul
YEAR: 1965
BRIAN-LIKES?: #T

RECORD 3
ARTIST: (THE ZOMBIES)
TITLE: Odessey and Oracle
YEAR: 1967
BRIAN-LIKES?: #T

RECORD 4
ARTIST: (FRANK ZAPPA)
TITLE: Hot Rats
YEAR: 1970
BRIAN-LIKES?: #F

RECORD 5
ARTIST: (THE BILL FRISELL BAND)
TITLE: Where in the World?
YEAR: 1991
BRIAN-LIKES?: #F

LISTED
Note: Don't invent a sorting algorithm for this problem. You can just use one of the sorting procedures from Chapter 15 and modify it slightly to sort a list of records instead of a sentence of words.

Sort-on-by

Although sort is a very general-purpose tool, the way that you have to specify how to sort the database is cumbersome. Write a procedure sort-on-by that takes two arguments, the name of a field and a predicate. It should invoke sort with an appropriate predicate to achieve the desired sort. For example, you could say

(sort-on-by 'title before?)
and

(sort-on-by 'year <)
instead of the two sort examples we showed earlier.

Generic-before?

The next improvement is to eliminate the need to specify a predicate explicitly. Write a procedure generic-before? that takes two arguments of any types and returns #t if the first comes before the second. The meaning of "before" depends on the types of the arguments:

If the arguments are numbers, generic-before? should use <. If the arguments are words that aren't numbers, then generic-before? should use before? to make the comparison.

What if the arguments are lists? For example, suppose you want to sort on the artist field in the albums example. The way to compare two lists is element by element, just as in the sent-before? procedure in Chapter 14.

> (generic-before? '(magical mystery tour) '(yellow submarine))
#T
> (generic-before? '(is that you?) '(before we were born))
#F
> (generic-before? '(bass desires) '(bass desires second sight))
#T
But generic-before? should also work for structured lists:

> (generic-before? '(norwegian wood (this bird has flown))
		   '(norwegian wood (tastes so good)))
#F
What if the two arguments are of different types? If you're comparing a number and a non-numeric word, compare them alphabetically. If you're comparing a word to a list, treat the word as a one-word list, like this:

> (generic-before? '(in line) 'rambler)
#T

> (generic-before? '(news for lulu) 'cobra)
#F
Sort-on

Now write sort-on, which takes the name of a field as its argument and sorts the current database on that field, using generic-before? as the comparison predicate.

Add-field

Sometimes you discover that you don't have enough fields in your database. Write a procedure add-field that takes two arguments: the name of a new field and an initial value for that field. Add-field should modify the current database to include the new field. Any existing records in the database should be given the indicated initial value for the field. Here's an example:

> (add-field 'category 'rock)
ADDED

> (edit-record 5)
CATEGORY: ROCK
ARTIST: (THE BILL FRISELL BAND)
TITLE: Where in the World?
YEAR: 1991
BRIAN-LIKES?: #F

Edit which field?  category
New value for CATEGORY--> jazz
CATEGORY: JAZZ
ARTIST: (THE BILL FRISELL BAND)
TITLE: Where in the World?
YEAR: 1991
BRIAN-LIKES?: #F

Edit which field?  #f
EDITED

> (list-db)
RECORD 1
CATEGORY: ROCK
ARTIST: (THE BEATLES)
TITLE: A Hard Day's Night (original soundtrack)
YEAR: 1964
BRIAN-LIKES?: #T

RECORD 2
CATEGORY: ROCK
ARTIST: (THE BEATLES)
TITLE: Rubber Soul
YEAR: 1965
BRIAN-LIKES?: #T

RECORD 3
CATEGORY: ROCK
ARTIST: (THE ZOMBIES)
TITLE: Odessey and Oracle
YEAR: 1967
BRIAN-LIKES?: #T

RECORD 4
CATEGORY: ROCK
ARTIST: (FRANK ZAPPA)
TITLE: Hot Rats
YEAR: 1970
BRIAN-LIKES?: #F

RECORD 5
CATEGORY: JAZZ
ARTIST: (THE BILL FRISELL BAND)
TITLE: Where in the World?
YEAR: 1991
BRIAN-LIKES?: #F

LISTED
If you like, you can write add-field so that it will accept either one or two arguments. If given only one argument, it should use #f as the default field value.

Note: We said earlier that each record is a vector but the collection of records is a list because we generally want to mutate fields in a record, but not add new ones, whereas we generally want to add new records, but not replace existing ones completely. This problem is an exception; we're asking you to add an element to a vector. To do this, you'll have to create a new, longer vector for each record. Your program will probably run slowly as a result. This is okay because adding fields to an existing database is very unusual. Commercial database programs are also slow at this; now you know why.

You can't solve this problem in a way that respects the current version of the record ADT. Think about trying to turn the record

#((THE BEATLES) "Rubber Soul" 1965 #T)
into the record

#(ROCK (THE BEATLES) "Rubber Soul" 1965 #T)
It seems simple enough: Make a new record of the correct size, and fill in all the values of the old fields from the old record. But does this happen before or after you change the list of current fields in the database? If before, you can't call blank-record to create a new record of the correct size. If after, you can't call get to extract the field values of the old record, because the field names have changed.

There are (at least) three solutions to this dilemma. One is to abandon the record ADT, since it's turning out to be more trouble than it's worth. Using the underlying vector tools, it would be easy to transform old-field records into new-field records.

The second solution is to create another constructor for records, adjoin-field. Adjoin-field would take a record and a new field value, and would be analogous to cons.

The last solution is the most complicated, but perhaps the most elegant. The reason our ADT doesn't work is that get, record-set!, and blank-record don't just get information from their arguments; they also examine the current fields of the database. You could write a new ADT implementation in which each procedure took a list of fields as an extra argument. Then get, record-set!, and blank-record could be implemented in this style:

(define (get fieldname record)
  (get-with-these-fields fieldname record (current-fields)))
Add-field could use the underlying ADT, and the rest of the program could continue to use the existing version.

We've put a lot of effort into figuring out how to design this small part of the overall project. Earlier we showed you examples in which using an ADT made it easy to modify a program; those were realistic, but it's also realistic that sometimes making an ADT work can add to the effort.

Save-selection

Write a save-selection procedure that's similar to save-db but saves only the currently selected records. It should take a file name as its argument.

Merge-db

One of the most powerful operations on a database is to merge it with another database. Write a procedure merge-db that takes two arguments: the file name of another database and the name of a field that the given database has in common with the current database. Both databases (the current one and the one specified) must already be sorted by the given field.

The effect of the merge-db command is to add fields from the specified database to the records of the current database. For example, suppose you had a database called "bands" with the following information:

Artist:                   Members:
(rush)                    (geddy alex neil)
(the beatles)             (john paul george ringo)
(the bill frisell band)   (bill hank kermit joey)
(the zombies)             (rod chris colin hugh paul)
You should be able to do the following (assuming "albums" is the current database):

> (sort-on 'artist)
ARTIST

> (merge-db "bands" 'artist)
MERGED

> (list-db)
RECORD 1
CATEGORY: ROCK
ARTIST: (FRANK ZAPPA)
TITLE: Hot Rats
YEAR: 1970
BRIAN-LIKES?: #F
MEMBERS: #F

RECORD 2
CATEGORY: ROCK
ARTIST: (THE BEATLES)
TITLE: A Hard Day's Night (original soundtrack)
YEAR: 1964
BRIAN-LIKES?: #T
MEMBERS: (JOHN PAUL GEORGE RINGO)

RECORD 3
CATEGORY: ROCK
ARTIST: (THE BEATLES)
TITLE: Rubber Soul
YEAR: 1965
BRIAN-LIKES?: #T
MEMBERS: (JOHN PAUL GEORGE RINGO)

RECORD 4
CATEGORY: JAZZ
ARTIST: (THE BILL FRISELL BAND)
TITLE: Where in the World?
YEAR: 1991
BRIAN-LIKES?: #F
MEMBERS: (BILL HANK KERMIT JOEY)

RECORD 5
CATEGORY: ROCK
ARTIST: (THE ZOMBIES)
TITLE: Odessey and Oracle
YEAR: 1967
BRIAN-LIKES?: #T
MEMBERS: (ROD CHRIS COLIN HUGH PAUL)

LISTED
Since there was no entry for Frank Zappa in the "bands" database, the members field was given the default value #f. If there are two or more records in the specified database with the same value for the given field, just take the information from the first one.

(By the way, this problem has a lot in common with the join procedure from Exercise 22.8.)

This is a complicated problem, so we're giving a hint:

(define (merge-db other-name common-field)
  (let ((other-db (read-db-from-disk other-name))
	(original-fields (current-fields)))
    (set-current-fields! (merge-fields original-fields
 				       (db-fields other-db)))
    (set-current-records! (merge-db-helper original-fields
					   (current-records)
					   (db-fields other-db)
					   (db-records other-db)
					   common-field))))
This procedure shows one possible overall structure for the program. You can fill in the structure by writing the necessary subprocedures. (If you prefer to start with a different overall design, that's fine too.) Our earlier suggestion about writing a get-with-these-fields procedure is relevant here also.
