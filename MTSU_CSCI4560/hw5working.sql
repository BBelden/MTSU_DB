if (OBJECT_ID('hw5.calcGPA','P') is not null)
    drop proc hw5.calcGPA
go

create procedure hw5.calcGPA
@M# varchar(20),
@gpa decimal(10,2) output
as
declare @grade varchar(2),
        @crdts int,
        @pts decimal(10,2)=0,
        @ttlPts decimal(10,2)=0,
        @ttlCrdtHrs decimal(10,2)=0,
        @ttlPtsXCrdtHrs decimal(10,2)=0

declare gpaCrsr cursor local
for
select hw5.Enroll.grade, hw5.Course.credit
from hw5.Student inner join hw5.Enroll on hw5.Student.M# = hw5.Enroll.M# 
inner join hw5.Section on hw5.Enroll.Sid = hw5.Section.Sid
inner join hw5.Course on hw5.Section.Course# = hw5.Course.Course#
where hw5.Student.M# = @M#;

open gpaCrsr;

fetch next from gpaCrsr into @grade, @crdts;

while @@FETCH_STATUS = 0
begin
set @pts = case @grade  when 'A' then 4.0
						when 'B' then 3.0
						when 'C' then 2.0
						when 'D' then 1.0
                        when 'F' then 0 end
set @ttlPts += (@pts*@crdts);
set @ttlCrdtHrs += @crdts;
--print 'pts '+ convert(varchar(10),@ttlPts);
--print 'hrs '+ convert(varchar(10),@ttlCrdtHrs);

fetch next from gpaCrsr into @grade, @crdts;
end

set @ttlPtsXCrdtHrs = @ttlPts * @ttlCrdtHrs;
set @gpa = @ttlPts / @ttlCrdtHrs;
return @gpa

close gpaCrsr;
deallocate gpaCrsr;

go


declare @input varchar(10) = 'M12345678';
declare @output decimal(10,2)
exec hw5.calcGPA @input, @output output;
	
print @output;





if (OBJECT_ID('hw5.hwTrigger','TR') is not null)
    drop trigger hw5.hwTrigger
go

create trigger hw5.hwTrigger
on hw5.Enroll
after update
as
begin
    if update (Grade)
    begin
        declare @mnum varchar(10);
        declare @newgpa decimal(10,2);
        declare crsr cursor local 
        for
        select M# from hw5.Enroll;
        open crsr;
        fetch next from crsr into @mnum;
        while @@FETCH_STATUS = 0
        begin
            exec calcGPA @mnum, @newgpa output;

            update hw3.Student
            set GPA = @newgpa
            where hw3.Student.M# = @mnum;

            fetch next from crsr into @mnum;
        end
        close crsr;
        deallocate crsr;
    end
end

go



update hw5.Enroll
set Grade = 'A'
where hw5.Enroll.Sid = 'D1';




if (OBJECT_ID('xscript','F') is not null)
    drop func xscript
go

create function hw5.xscript
@M#,
returns @tempTbl table (
    Course# varchar(45),
    Name varchar(45),
    Credits int,
    Grade varchar(45))
as
begin
    select hw5.Course.Course#, hw5.Course.Name, hw5.Course.credit, hw5.Enroll.Grade from 
    hw5.Course inner join hw5.Section on hw5.Section.Course# = hw5.Course.C#
    inner join hw5.Enroll on hw5.Section.Sid = hw5.Enroll.Sid
    inner join hw5.Student on hw5.Enroll.M# = hw5.Student.M#
    where hw5.Student.M# = @M#
    order by hw5.Section.Year,case hw5.Section.Semester
							    when 'Spring' then 1
						    	when 'Summer' then 2
							    when 'Fall' then 3
							    else 4
							    end, hw5.Section.Semester
    return
end
go





