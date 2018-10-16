create schema hw5 
go 

create table hw5.Student (
	M# varchar(10) not null primary key,
	Name varchar(255) not null,
	Sex varchar(10) not null,
	GPA decimal(10,2) not null
);
go

create table hw5.Enroll (
	M# varchar(10) not null,
	Sid varchar(45) not null,
	Grade varchar(45) not null,
	primary key (M#,Sid)
);
go

create table hw5.Course (
	Course# varchar(45) not null primary key,
	Name varchar(45) not null,
	C# varchar(45) not null,
	credit int not null
);
go

create table hw5.Section (
	Course# varchar(45) not null,
	Sect# varchar(45) not null,
	Semester varchar(45) not null,
	Year int not null,
	Sid varchar(45) not null primary key
);
go

alter table hw5.Enroll
add constraint fk_stu_m
foreign key (M#)
references hw5.Student (M#);
go

alter table hw5.Enroll
add constraint fk_sect_sid
foreign key (Sid)
references hw5.Section (Sid)
go

alter table hw5.Course
add constraint fk_crse_num
foreign key (C#)
references hw5.Course (Course#)
go



drop table hw5.Course
go
drop table hw5.Section
go
drop table hw5.Enroll
go
drop table hw5.Student
go
drop schema hw5
go





insert into hw5.Student (M#, Name, Sex, GPA) values ('M12345678','John','M','0'); 
insert into hw5.Student (M#, Name, Sex, GPA) values ('M23456789','Mary','F','0'); 
insert into hw5.Student (M#, Name, Sex, GPA) values ('M34567890','Pete','M','0'); 
insert into hw5.Student (M#, Name, Sex, GPA) values ('M45678901','Martha','F','0'); 
insert into hw5.Student (M#, Name, Sex, GPA) values ('M56789012','Frank','M','0'); 
insert into hw5.Student (M#, Name, Sex, GPA) values ('M67890123','Wanda','F','0'); 
insert into hw5.Student (M#, Name, Sex, GPA) values ('M78901234','Walter','M','0'); 
insert into hw5.Student (M#, Name, Sex, GPA) values ('M89012345','Corinne','F','0'); 
insert into hw5.Student (M#, Name, Sex, GPA) values ('M90123456','Ben','M','0'); 
insert into hw5.Student (M#, Name, Sex, GPA) values ('M01234567','Liz','F','0'); 



insert into hw5.Course (Course#,Name,C#,credit) values ('1','A','','6'); 
insert into hw5.Course (Course#,Name,C#,credit) values ('2','B','1','4'); 
insert into hw5.Course (Course#,Name,C#,credit) values ('3','C','2','3'); 
insert into hw5.Course (Course#,Name,C#,credit) values ('4','D','3','5'); 
insert into hw5.Course (Course#,Name,C#,credit) values ('5','E','4','2'); 



insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('1','1','FALL','2011','A1'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('1','1','FALL','2012','A2'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('1','1','FALL','2013','A3'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('1','1','FALL','2011','A4'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('1','1','FALL','2012','A5'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('1','1','FALL','2013','A6'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('1','1','FALL','2011','A7'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('1','1','FALL','2012','A8'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('1','1','FALL','2013','A9'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('1','1','FALL','2011','A10'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('2','1','FALL','2011','B1'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('2','1','FALL','2012','B2'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('2','1','FALL','2013','B3'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('2','1','FALL','2011','B4'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('2','1','FALL','2012','B5'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('2','1','FALL','2013','B6'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('2','1','FALL','2011','B7'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('2','1','FALL','2012','B8'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('2','1','FALL','2013','B9'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('2','1','FALL','2011','B10'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('3','1','FALL','2011','C1'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('3','1','FALL','2012','C2'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('3','1','FALL','2013','C3'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('3','1','FALL','2011','C4'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('3','1','FALL','2012','C5'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('3','1','FALL','2013','C6'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('3','1','FALL','2011','C7'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('3','1','FALL','2012','C8'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('3','1','FALL','2013','C9'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('3','1','FALL','2011','C10'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('4','1','FALL','2011','D1'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('4','1','FALL','2012','D2'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('4','1','FALL','2013','D3'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('4','1','FALL','2011','D4'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('4','1','FALL','2012','D5'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('4','1','FALL','2013','D6'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('4','1','FALL','2011','D7'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('4','1','FALL','2012','D8'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('4','1','FALL','2013','D9'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('4','1','FALL','2011','D10'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('5','1','FALL','2011','E1'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('5','1','FALL','2012','E2'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('5','1','FALL','2013','E3'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('5','1','FALL','2011','E4'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('5','1','FALL','2012','E5'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('5','1','FALL','2013','E6'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('5','1','FALL','2011','E7'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('5','1','FALL','2012','E8'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('5','1','FALL','2013','E9'); 
insert into hw5.Section (Course#,Sect#,Semester,Year,Sid) values ('5','1','FALL','2011','E10'); 





insert into hw5.Enroll (M#,Sid,Grade) values ('M12345678','A1','A'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M23456789','A2','B'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M34567890','A3','C'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M45678901','A4','A'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M56789012','A5','B'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M67890123','A6','C'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M78901234','A7','A'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M89012345','A8','B'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M90123456','A9','C'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M01234567','A10','A'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M12345678','B1','B'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M23456789','B2','C'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M34567890','B3','A'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M45678901','B4','B'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M56789012','B5','C'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M67890123','B6','A'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M78901234','B7','B'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M89012345','B8','C'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M90123456','B9','A'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M01234567','B10','B'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M12345678','C1','C'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M23456789','C2','B'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M34567890','C3','A'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M45678901','C4','C'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M56789012','C5','B'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M67890123','C6','A'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M78901234','C7','C'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M89012345','C8','B'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M90123456','C9','A'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M01234567','C10','C'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M12345678','D1','D'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M23456789','D2','B'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M34567890','D3','C'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M45678901','D4','A'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M56789012','D5','D'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M67890123','D6','B'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M78901234','D7','C'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M89012345','D8','A'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M90123456','D9','D'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M01234567','D10','B'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M12345678','E1','C'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M23456789','E2','B'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M34567890','E3','C'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M45678901','E4','D'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M56789012','E5','A'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M67890123','E6','B'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M78901234','E7','C'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M89012345','E8','D'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M90123456','E9','A'); 
insert into hw5.Enroll (M#,Sid,Grade) values ('M01234567','E10','B'); 