
CREATE table if not exists book(
	isbn char(13) not null,
    title varchar(80) not null,
    author varchar(80) not null,
    category varchar(80) not null,
    price int(4) unsigned not null,
    copies int(10) unsigned not null
);

Insert into book values
('9788654552277', 'X-Men: God Loves, Man Kills', 'Chris', 'Comics', 98, 39),
('6901142585540', 'V for Vendetta', 'Alan Moore', 'Comics', 600, 23),
('9094996245442', 'When Breath Becomes Air', 'Paul Kalanithi', 'Medical', 500, 94),
('8653491200700', 'The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 432, 120);

create table if not exists book_issue
(issue_id int(11) not null,
member varchar(20) not null,
book_isbn varchar(13) not null,
due_date date not null,
last_reminded date default null
);

Delimiter //
create trigger issue_book before insert on book_issue
for each row
Begin
Set new.due_date = date_add(current_date,interval 20 day);
update member set balance = balance - (select price from book where isbn = new.book_isbn) where username = new.member;
update book set copies = copies - 1 where isbn = new.book_isbn;
delete from pending_book_requests where member = new.member and book_isbn = new.book_isbn;
end;//

Delimiter //
create trigger return_book before delete on book_issue
for each row
Begin
update member set balance = balance + (select price from book where isbn = old.book_isbn) where username = old.member;
update book set copies = copies + 1 where isbn = old.book_isbn;
end;//

create table if not exists librarian(
id int(11) not null,
username varchar(20) not null,
password char(40) not null
);

insert into librarian values(1, 'Vani', 'xthds97@3h$yfc*jrk0%dfg$');

create table if not exists member(
id int(11) not null,
username varchar(20) not null,
password char(40) not null,
name varchar(80) not null,
email varchar(80) not null,
balance int(4) not null
);

create trigger add_member after insert on member
For Each Row
delete from pending_registration where username = new.username;

create trigger remove_member after delete on member
For Each Row 
delete from pending_book_requests where member = old.username;

create table if not exists pending_book_requests(
	request_id int(11) not null,
    member varchar(20) not null,
    book_isbn varchar(13) not null,
    time timestamp not null default current_timestamp
    );
    
create table if not exists pending_registrations
(
username varchar(30) not null,
password char(20) not null,
name varchar(40) not null,
email varchar(20) not null,
balance int(10),
time timestamp not null default current_timestamp
);

insert into pending_registrations values 
('Robin200', '7t6hg$56y^', 'Robin', 'robin@gmail.com', 200, '2021-03-21 08:59:00'),
('Aadhya100', 'Ujgf(76G5$#f@df', 'Aadhya', 'aadhya100@gmail.com', 1500, '2021-03-21 2:14:53');

Alter table book add primary key (isbn);
Alter table book_issue add primary key (issue_id);
Alter table librarian add primary key (id), add unique key (username);
Alter table member add primary key (id),add unique key (username),add unique key (email);
Alter table pending_book_requests add primary key (request_id);
Alter table pending_registrations add primary key (username);


