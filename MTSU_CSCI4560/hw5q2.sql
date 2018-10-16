-- Ben Belden
-- homework 5 
-- question 2
-- 11/18/2014


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
