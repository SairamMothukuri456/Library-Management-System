create database lib;
use lib;

-- Table: tbl_publisher
CREATE TABLE tbl_publisher (
    publisher_PublisherName VARCHAR(255) PRIMARY KEY,
    publisher_PublisherAddress TEXT,
    publisher_PublisherPhone VARCHAR(15)
);

-- Table: tbl_book
CREATE TABLE tbl_book (
    book_BookID INT PRIMARY KEY,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(255),
    FOREIGN KEY (book_PublisherName) REFERENCES tbl_publisher(publisher_PublisherName)
);

-- Table: tbl_book_authors
CREATE TABLE tbl_book_authors (
    book_authors_AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    book_authors_BookID INT,
    book_authors_AuthorName VARCHAR(255),
    FOREIGN KEY (book_authors_BookID) REFERENCES tbl_book(book_BookID)
);

-- Table: tbl_library_branch
CREATE TABLE tbl_library_branch (
    library_branch_BranchID INT PRIMARY KEY AUTO_INCREMENT,
    library_branch_BranchName VARCHAR(255),
    library_branch_BranchAddress TEXT
);

-- Table: tbl_book_copies
CREATE TABLE tbl_book_copies (
    book_copies_CopiesID INT PRIMARY KEY AUTO_INCREMENT,
    book_copies_BookID INT,
    book_copies_BranchID INT,
    book_copies_No_Of_Copies INT,
    FOREIGN KEY (book_copies_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_copies_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID)
);

-- Table: tbl_borrower
CREATE TABLE tbl_borrower (
    borrower_CardNo INT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(255),
    borrower_BorrowerAddress TEXT,
    borrower_BorrowerPhone VARCHAR(15)
);

-- Table: tbl_book_loans
CREATE TABLE tbl_book_loans (
    book_loans_LoansID INT PRIMARY KEY AUTO_INCREMENT,
    book_loans_BookID INT,
    book_loans_BranchID INT,
    book_loans_CardNo INT,
    book_loans_DateOut DATE,
    book_loans_DueDate DATE,
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID),
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo)
);
select * from tbl_publisher;
select * from tbl_book;
select * from tbl_book_authors;
select * from tbl_library_branch;
select * from tbl_book_copies;
select * from tbl_borrower;
select * from tbl_book_loans;

## Task Questions

-- 1.How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select bc.book_copies_No_Of_Copies
from tbl_book_copies bc
join tbl_book b on bc.book_copies_BookID=b.book_BookID
join tbl_library_branch lb on bc.book_copies_BranchID=lb.library_branch_BranchID
where b.book_Title='The Lost Tribe'
and lb.library_branch_BranchName='Sharpstown';


-- 2.How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select lb.library_branch_BranchName,sum(bc.book_copies_No_Of_Copies) as TotalCopies
from tbl_book_copies bc
join tbl_book b on bc.book_copies_BookID=b.book_BookID
join tbl_library_branch lb on bc.book_copies_BranchID=lb.library_branch_BranchID
where b.book_Title='The Lost Tribe'
group by lb.library_branch_BranchName;


-- 3.Retrieve the names of all borrowers who do not have any books checked out.
select tb.borrower_BorrowerName
from tbl_borrower tb
left join tbl_book_loans tbl
on tb.borrower_CardNo=tbl.book_loans_BookID
where tbl.book_loans_CardNo IS NULL;


-- 4.For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's
-- name, and the borrower's address.
select tb.book_Title,tlb.borrower_BorrowerName,tlb.borrower_BorrowerAddress
from tbl_borrower tlb
join tbl_book_loans tbb on tbb.book_loans_CardNo=tlb.borrower_CardNo
join tbl_book tb on tb.book_BookID=tbb.book_loans_BookID
join tbl_library_branch tl on tl.library_branch_BranchID=tbb.book_loans_BranchID
where tl.library_branch_BranchName='Sharpstown' and tbb.book_loans_DueDate='2/3/18';


-- 5.For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select tlb.library_branch_BranchName,count(*)
from tbl_library_branch tlb
join tbl_book_loans tbl on tbl.book_loans_BranchID=tlb.library_branch_BranchID
group by tlb.library_branch_BranchName
order by tlb.library_branch_BranchName;


-- 6.Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
select tb.borrower_BorrowerName,tb.borrower_BorrowerAddress,tb.borrower_BorrowerPhone,count(*)
from tbl_borrower tb
join tbl_book_loans tbl on tbl.book_loans_CardNo=tb.borrower_CardNo
group by tb.borrower_BorrowerName,tb.borrower_BorrowerAddress,tb.borrower_BorrowerPhone
having count(*)>5
order by tb.borrower_BorrowerName;


-- 7.For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is 
-- "Central".
select tb.book_Title,SUM(tbc.book_copies_No_Of_Copies) as TotalCopies
from tbl_book tb
join tbl_book_authors tba on tba.book_authors_BookID=tb.book_BookID
join tbl_book_copies tbc on tbc.book_copies_BookID=tb.book_BookID
join tbl_library_branch lb on tbc.book_copies_BranchID=lb.library_branch_BranchID
where tba.book_authors_AuthorName='Stephen King'
and lb.library_branch_BranchName='Central'
group by tb.book_Title
order by tb.book_Title;



