-- Ben Belden
-- homework 5 
-- question 1
-- 11/18/2014


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
-- print 'pts '+ convert(varchar(10),@ttlPts);
-- print 'hrs '+ convert(varchar(10),@ttlCrdtHrs);

fetch next from gpaCrsr into @grade, @crdts;
end

set @ttlPtsXCrdtHrs = @ttlPts * @ttlCrdtHrs;
set @gpa = @ttlPts / @ttlCrdtHrs;
return @gpa

close gpaCrsr;
deallocate gpaCrsr;

go
