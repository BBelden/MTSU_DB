-- Explanation of the data model:
/*
The CIS Department maintains the Free Access to Current Technology (FACT) library. FACT
is a collection of current technology books for use by faculty and staff. A book must
have at least one author but can have many. An author must have written at least one book 
to be included in the system, but may have written many. A book may have never been checked
out, but can be checked out many times by the same patron or different patrons over time. 
Since all faculty and staff in the department are given accounts at the library, a patron
may not have ever checked out a book or they may have checked out many books over time. To
simplify determining which patron currently has a given book checked out, a redundant 
relationship between BOOK and PATRON is maintained.
*/

/*
Create the following tables in your account using CTAS commands to copy the table structures
and data from the FACT schema.
*/
CREATE TABLE patron AS SELECT * FROM fact.patron;
CREATE TABLE author AS SELECT * FROM fact.author;
CREATE TABLE book AS SELECT * FROM fact.book;
CREATE TABLE checkout AS SELECT * FROM fact.checkout;
CREATE TABLE writes AS SELECT * FROM fact.writes;


-- 1 --
/*
Write a query that displays the book title, cost, and year of publication for every book
in the system.
*/
SELECT book_title, book_cost, book_year FROM book;


-- 2 --
/*
Write a query that displays the first and last name of every patron.
*/
SELECT pat_fname, pat_lname FROM patron;


-- 3 --
/*
Write a query to display the checkout number, check out date, and due date for every book
that has been checked out.
*/
SELECT CHECK_num, check_out_date, check_due_date FROM checkout;


-- 4 --
/*
Write a query to display the book number, book title, and year of publication for every book.
*/
SELECT book_num,book_title AS title,book_year AS "Year Published" FROM book;


-- 5 --
/*
Write a query to display the different years that books have been published in. Include each
year only once.
*/
SELECT DISTINCT book_year FROM book;


-- 6 --
/*
Write a query to display the different dubjects that FACT has books on. Include each subject
only once.
*/
SELECT DISTINCT book_subject FROM book;


-- 7 --
/*
Write a query to display the patron ID, book number, and days kept for each checkout. The 
days kept is the difference from the date on which the book is returned to the date it was
checked out.
*/
SELECT patron.pat_id AS patron, book_num AS book,
check_in_date - check_out_date AS "Days Kept"
FROM patron JOIN checkout ON patron.pat_id = checkout.pat_id;


-- 8 --
/*
Write a query to display the book number, title, and cost of each book.
*/
SELECT book_num, book_title,
To_Char(book_cost,'$999.99') AS "Replacement Cost" FROM book;


-- 9 --
/*
Write a query to display the patron ID, patron full name, and patron type for each patron.
*/
SELECT pat_id, pat_fname || ' ' || pat_lname AS "Patron Name",
pat_type FROM patron;


-- 10 --
/*
Write a query to display the book number, title with year, and subject for each book.
*/
SELECT book_num, book_title || ' (' || book_year || ')' AS book,
book_subject FROM book;


-- 11 --
/*
Write a query to display the author last name, author first name, and book number
for each book written by that author.
*/
SELECT au_lname, au_fname, book_num FROM writes
JOIN author ON author.au_id = writes.au_id;


-- 12 --
/*
Write a query to display the author id, book number, titls and year for each book.
*/
SELECT au_id,book.book_num,book_title,book_year FROM writes
JOIN book ON book.book_num = writes.book_num;


-- 13 --
/*
Write a query to display the author last name, first name, book title and year for each book.
*/
SELECT au_lname, au_fname, book_title, book_year
FROM book JOIN writes ON book.book_num = writes.book_num
JOIN author ON writes.au_id = author.au_id;


-- 14 --
/*
Write a query to display the checkout number, book number, patron id, checkout date and 
due date for every checkout that has ever occurred in the system. Sort the results by
checkout date in descending order.
*/
SELECT CHECK_num, book_num, pat_id, check_out_date, check_due_date
FROM checkout ORDER BY check_out_date desc;


-- 15 --
/*
Write a query to display the book title, year, and subject for every book. Sort the
results by book subject in ascending order, year in descening order, and then title
in ascending order.
*/
SELECT book_title,book_year,book_subject FROM book
ORDER BY book_subject, book_year DESC, book_title;


-- 16 --
/*
Write a query to display the patron id, book number, patron first name and last name,
and book title for all currently checked out books.
*/
SELECT patron.pat_id,book_num,pat_fname,pat_lname,book_title
FROM patron JOIN book ON patron.pat_id = book.pat_id;


-- 17 --
/*
Write a query to display the book number, title, and year for all books published in 2013.
*/
SELECT book_num,book_title,book_year FROM book WHERE book_year = 2013;


-- 18 --
/*
Write a query to display the book number, title and year of publication for all books in 
the "Database" subject.
*/
SELECT book_num,book_title,book_year FROM book WHERE book_subject = 'Database';


-- 19 --
/*
Write a query to display the checkout number, book number, and checkout date of all books 
checked out before April 5, 2016.
*/
SELECT check_num,book_num,check_out_date FROM checkout
WHERE check_out_date < '05-APR-16';


-- 20 --
/*
Write a query to display the book number, title and year of all books published after
2014 and on the subject of "Programming".
*/
SELECT book_num,book_title,book_year FROM book
WHERE book_subject = 'Programming' AND book_year > 2014;


-- 21 --
/*
Write a query to display the book number, title, year of publication, subject, and cost
for all books that are on the subjects of "Middleware" or "Cloud", and that cost more
than $70.
*/
SELECT book_num,book_title,book_year,book_subject,book_cost FROM book
WHERE (book_subject = 'Middleware' OR book_subject = 'Cloud') AND book_cost > 70;


-- 22 --
/*
Write a query to display the author ID, first name, last name, and year of birth for all
authors born in the decade of the 1980s.
*/
SELECT * FROM author WHERE au_birthyear BETWEEN 1980 AND 1989;


-- 23 --
/*
Write a query to display the book number, title, and year of publication for all books
that contain the word "Database" in the title, regardless of how it is capitalized.
*/
SELECT book_num,book_title AS "Title",book_year AS "Year Published"
FROM book WHERE Upper(book_title) LIKE '%DATABASE%';


-- 24 --
/*
Write a query to display the patron ID, first and last name of all patrons that are students.
*/
SELECT pat_id,pat_fname,pat_lname FROM patron WHERE Upper(pat_type) = 'STUDENT';


-- 25 --
/*
Write a query to display the patron ID, first and last name, and patron type for all patrons
whose last name begins with the letter "C".
*/
SELECT * FROM patron WHERE Upper(pat_lname) LIKE 'C%';


-- 26 --
/*
Write a query to display the authoer ID, first and last name of all authors whose year of 
birth is unknown.
*/
SELECT au_id,au_fname,au_lname FROM author WHERE au_birthyear IS NULL;


-- 27 --
/*
Write a query to display the author ID, first and last name of all authors whos year of 
birth is known.
*/
SELECT au_id,au_fname,au_lname FROM author WHERE au_birthyear IS NOT NULL;


-- 28 --
/*
Write a query to display the checkout number, book number, patron ID, check out date, and
due date for all checkouts that have not been returned yet. Sort the results by book number.
*/
SELECT check_num,book_num,pat_id,check_out_date,check_due_date
FROM checkout WHERE check_in_date IS NULL ORDER BY book_num;


-- 29 --
/*
Write a query to display the author ID, first name, last name, and year of birth for all 
authors. Sort the results in descending order by year of birth, and then in ascending
order by last name.
*/
SELECT * FROM author ORDER BY au_birthyear DESC, au_lname;


-- 30 --
/*
Write a query to display the patron ID, full name (first and last), and patron type
ofr all patrons. Sort the results by patron type, then by last name and first name. 
Ensure that all sorting is case insensitive.
*/
SELECT pat_id,pat_fname || ' ' || pat_lname AS name, pat_type
FROM
(
  SELECT * FROM patron
  ORDER BY Upper(pat_type), Upper(pat_lname), Upper(pat_fname)
);


-- 31 --
/*
Write a query to display the number of books that are in the FACT system.
*/
SELECT Count(book_num) AS "Number of Books" FROM book;


-- 32 --
/*
Write a query to display the number of different book subjects in the FACT system.
*/
SELECT Count(DISTINCT book_subject) AS "Number of Subjects" FROM book;


-- 33 --
/*
Write a query to display the number of books that are available.
*/
SELECT Count(*) AS "Available Books" FROM book WHERE pat_id IS NULL;


-- 34 --
/*
Write a query to display the highest book cost in the system.
*/
SELECT To_Char(Max(book_cost),'$999.99') AS "Most Expensive" FROM book;


-- 35 --
/*
Write a query to display the lowest book cost in the system.
*/
SELECT To_Char(Min(book_cost),'$999.99') AS "Least Expensive" FROM book;


-- 36 --
/*
Write a query to display the number of different patrons that have ever checked out
a book
*/
SELECT Count(DISTINCT pat_id) AS "DIFFERENT PATRONS" FROM checkout;


-- 37 --
/*
Write a query to display the subject and the number of books in each subject.
*/
SELECT book_subject,count(*) AS "Books In Subject" FROM book GROUP BY book_subject;


-- 38 --
/*
Write a query to display the author ID and the number of books written by that author.
*/
SELECT author.au_id, Count(*) AS "Books Written"
FROM author JOIN writes ON author.au_id = writes.au_id GROUP BY author.au_id
ORDER BY "Books Written" DESC, au_id;


-- 39 --
/*
Write a query to display the total value of all books in the library.
*/
SELECT To_Char(Sum(book_cost),'$9,999.99') AS "Library Value" FROM book;


-- 40 --
/*
Write a query to display the book number and the number of times each book has been 
checked out. Do not include books that have never been checked out.
*/
SELECT book_num,Count(*) AS "Times Checked Out"
FROM checkout GROUP BY book_num ORDER BY "Times Checked Out" DESC, book_num;


-- 41 --
/*
Write a query to display the author ID, first and last name, book number, and book title
of all books in the subject "Cloud". Sort the results by book title and then by author
last name.
*/
SELECT author.au_id,au_fname,au_lname,book.book_num,book_title
FROM book JOIN writes ON book.book_num = writes.book_num
JOIN author ON writes.au_id = author.au_id WHERE book_subject = 'Cloud';


-- 42 --
/*
Write a query to display the book number, title, patron ID, last name, and patron type
for all books currently checked out to a patron. Sort the results by book title.
*/
SELECT book_num,book_title,patron.pat_id,pat_lname,pat_type
FROM book JOIN patron ON book.pat_id = patron.pat_id WHERE book.pat_id IS NOT NULL;


-- 43 --
/*
Write a query to display the book number, title, and number of times each book has been
checked out. Include books that have never been checked out. Sort the results in 
descending order by the number of times checked out, then by title.
*/
SELECT t.book_num,book_title,
CASE cnt WHEN 1 THEN 0 ELSE cnt END AS "Times Checked Out" FROM
(
  SELECT book.book_num,count(*) AS cnt
  FROM book left JOIN checkout ON book.book_num = checkout.book_num
  GROUP BY book.book_num
) t
JOIN book ON t.book_num = book.book_num
ORDER BY "Times Checked Out" desc,book_title;

SELECT book.book_num, book_title, Count(check_out_date) AS "Times Checked Out"
FROM book JOIN checkout ON book.book_num = checkout.book_num
GROUP BY book.book_num, book_title
ORDER BY "Times Checked Out" DESC, book_title;


-- 44 --
/*
Write a query to display the book number, title, and number of times each book has 
been checked out. Limit the results to books that have been checked out more than
5 times. Sort the results in descening order by the number of times checked out, 
and then by title.
*/
SELECT book.book_num,book_title,cnt AS "Times Checked Out" FROM
(
  SELECT book_num,Count(*) AS cnt FROM checkout
  GROUP BY book_num HAVING Count(*) > 5
) t
JOIN book ON book.book_num = t.book_num
ORDER BY "Times Checked Out" DESC,book_title;


-- 45 --
/*
Write a query to display the author ID, author last name, book title, checkout date,
and patron last name for all the books written by authors with the last name "Bruer"
that have ever been checked out by patrons with the last name "Miles".
*/
SELECT author.au_id,au_lname,book_title,check_out_date,pat_lname
FROM book   JOIN checkout ON book.book_num = checkout.book_num
            JOIN patron ON checkout.pat_id = patron.pat_id
            JOIN writes ON book.book_num = writes.book_num
            JOIN author ON writes.au_id = author.au_id
WHERE au_lname = 'Bruer' AND pat_lname = 'Miles';


-- 46 --
/*
Write a query to display the patron ID, first and last name of all patrons that have 
never checked out any book. Sort the result by patron last name then first name.
*/
SELECT pat_id,pat_fname,pat_lname FROM patron WHERE pat_id NOT IN
(
  SELECT DISTINCT patron.pat_id FROM patron
  JOIN checkout ON patron.pat_id = checkout.pat_id
)
ORDER BY pat_lname,pat_fname;


-- 47 --
/*
Write a query to display the book number and title of books that have never been checked
out by any patron. Sort the results by book title.
*/
SELECT book_num,book_title FROM book WHERE book_num NOT IN
(
  SELECT DISTINCT book_num FROM checkout
)
ORDER BY book_title;


-- 48 --
/*
Write a query to display the patron ID, last name, number of times that patron has checked 
out a book, and the number of different books the patron has ever checked out. For example, 
if a given patron has checked out the same book twice, that would count as 2 checkouts but 
only 1 book. Limit the results to only patrons that have made at least 3 checkouts. Sort
the results in descending order by number of books, then in descending order by number of
checkouts, then in ascending order by patron ID.
*/
SELECT p.pat_id,pat_lname,ckout AS "NUM CHECKOUTS",bks AS "NUM DIFFERENT BOOKS"
FROM
-- number of times ever checked out a book, only 3 ckouts
(
  SELECT pat_id,Count(book_num) AS ckout FROM checkout
  GROUP BY pat_id HAVING Count(book_num) > 2
) ck
JOIN
-- number of distinct books checked out
(
  SELECT pat_id,Count(DISTINCT book_num )AS bks
  FROM checkout GROUP BY pat_id
) bk
ON ck.pat_id = bk.pat_id JOIN patron p ON p.pat_id = ck.pat_id
ORDER BY "NUM DIFFERENT BOOKS" DESC, "NUM CHECKOUTS",pat_id;


-- 49 --
/*
Write a query to display the average number of days a book is kept during a checkout.
*/
SELECT To_Char(Avg(check_in_date - check_out_date),'9.99') FROM checkout;


-- 50 --
/*
Write a query to display the patron ID and the average number of days that patron keeps 
books during a checkout. Limit the results to only patrons that have at least 3 
checkouts. Sort the results in descending order by the average days the book is kept.
*/
SELECT t.pat_id, To_Char(Avg(check_in_date - check_out_date),'9.99')
AS "Average Days Kept" FROM
(
  SELECT pat_id,Count(*) AS cnt
  FROM checkout GROUP BY pat_id HAVING Count(*) > 2
) t
JOIN checkout ON checkout.pat_id = t.pat_id
GROUP BY t.pat_id
ORDER BY "Average Days Kept" DESC;


-- 51 --
/*
Write a query to display the book number, title, and cost of books that cost more than
the average book cost. Sort the results by the book title.
*/
SELECT book_num,book_title,book_cost FROM book WHERE book_cost >
(
  SELECT Avg(book_cost) FROM book
)
ORDER BY book_title;


-- 52 --
/*
Write a query to display the book number, title, and cost of books that have the lowest
cost of any books in the system. Sort the results by book number.
*/
SELECT book_num,book_title,book_cost FROM book WHERE book_cost =
(
  SELECT Min(book_cost) FROM book
)
ORDER BY book_num;


-- 53 --
/*
Write a query to display the author ID, first and last name for all authors that have 
never written a book with the subject "Programming". Sort the results by author last name.
*/
SELECT au_id,au_fname,au_lname FROM author WHERE au_id NOT IN
(
  SELECT au_id FROM book JOIN writes ON book.book_num = writes.book_num
  WHERE book_subject = 'Programming'
)
ORDER BY au_lname;


-- 54 --
/*
Write a query to display the book number, title, subject, average cost of books written
in that subject, and the difference bewteen each book's cost and the average cost of 
books in that subject. Sort the results by book title.
*/
SELECT book_num,book_title,book.book_subject,
To_Char(avgcost,'$99.99') AS "Average Subject Cost",
To_Char((book_cost - avgcost),'$99.99') AS difference FROM
(
  SELECT book_subject, Avg(book_cost) AS avgcost
  FROM book GROUP BY book_subject
) t
JOIN book ON book.book_subject = t.book_subject
ORDER BY book_title;


-- 55 --
/*
Write a query to display the book number, title, subject, author last name, and the number 
of books written by that author. Limit the results to books in the "Cloud" subject. Sort
the results by book title and then author last name.
*/
SELECT book.book_num,book_title,book_subject,au_lname,
bookcount AS "Num Books by Author" FROM
(
  SELECT author.au_id,Count(book_num) AS bookcount
  FROM writes JOIN author ON writes.au_id = author.au_id
  GROUP BY author.au_id
) t
JOIN writes ON t.au_id = writes.au_id
  JOIN book ON writes.book_num = book.book_num
  JOIN author ON t.au_id = author.au_id
WHERE book_subject = 'Cloud' ORDER BY book_title,au_lname;


-- 56 --
/*
Write a query to display the lowest average cost of books within a subject and the highest
average cost of books within a subject.
*/
SELECT To_Char(Min(avgcost),'99.99') AS "Lowest Avg Cost",
To_Char(Max(avgcost),'99.99') AS "Highest Avg Cost" FROM
(
  SELECT Avg(book_cost) AS avgcost
  FROM book GROUP BY book_subject
);
