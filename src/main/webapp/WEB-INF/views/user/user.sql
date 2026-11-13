show tables;

create table user (
	idx 			int 					 not null auto_increment,
	mid 			varchar(20) 	 not null,	
	name 			varchar(20)		 not null,
	age 			int 			  	 default 20,
	address 	varchar(100)	 default '서울',
	
	primary key(idx)
);

desc user;

insert into user values (default, 'admin', '관리자', 27, '서울시 마포구');
insert into user values (default, 'test1', '홍길동', 21, '서울시 관악구');
insert into user values (default, 'test2', '이기자', 13, '서울시 은평구');
insert into user values (default, 'test3', '김말숙', 37, '서울시 송파구');
insert into user values (default, 'test4', '김연아', 24, '서울시 강남구');

select * from user;
