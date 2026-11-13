create table guest (
  idx  				int 					not null auto_increment,	
  nickName 		varchar(20) 	not null,		
  pwd					varchar(100)	not null,
  content 		text 					not null,				
  email 			varchar(60),					
  hostIP   		varchar(30) 	not null,
  wDate 			datetime 			default now(), 
  
  primary key(idx)
);

desc guest;

insert into guest values (default, '관리자', '방명록 서비스를 시작합니다.', 'admin1234@naver.com', '192.168.50.20', default);
insert into guest values (default, '관리자', '테스트용 게시입니다.', 'admin1234@naver.com', '192.168.50.20', default);

select * from guest;