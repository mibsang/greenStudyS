show tables;

create table user2 (
	idx 			int 					 not null auto_increment,
	mid 			varchar(20) 	 not null,	
	pwd 			varchar(100) 	 not null,	
	name 			varchar(20)		 not null,
	age 			int 			  	 default 20,
	gender		char(2)				 default '여자',
	address 	varchar(100)	 default '서울',
	
	primary key(idx),
	unique(mid)
);

desc user2;

insert into user2 values (default, 'admin', '1234', '관리자', 27, default, '서울시 마포구');

select * from user2;

select distinct gender from user2 order by gender;
