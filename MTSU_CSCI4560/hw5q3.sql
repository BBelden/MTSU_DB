-- Ben Belden
-- homework 5 
-- question 3
-- 11/18/2014


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
