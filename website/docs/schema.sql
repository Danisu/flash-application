/*
	Provide schema for website database which stores user
	records and deck databases.
	MySQL format

*/

create table users (
	name varchar(30) not null,
	email varchar(30) not null,
	password char(60) not null,
	date timestamp not null default current_timestamp,
	constraint unique (name)
);

create table deckdbs (
	id int unsigned not null auto_increment,
	username varchar(30) not null,
	name varchar(30) not null,
	deckdesc text,
	size int unsigned not null,
	numcards int unsigned not null,
	private bool not null,
	date timestamp not null default current_timestamp,
	deckdb longblob not null,
	primary key (id)
);
