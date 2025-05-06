create database HospitalDB;
go
use HospitalDB;
go

create table Departments
(
    DepartmentID int primary key identity(1,1) not null,
    DepartmentBuilding int check (DepartmentBuilding between 1 and 5) not null,
    DepartmentName nvarchar(100) not null unique check (DepartmentName <> ''),
);
go

create table Doctors
(
    DoctorID int primary key identity(1,1) not null,
    DoctorName nvarchar(50) not null check (DoctorName <> ''),
    DoctorSurname nvarchar(50) not null check (DoctorSurname <> ''),
    DoctorPremium money not null check (DoctorPremium >= 0) default 0,
    DoctorSalary money not null check (DoctorSalary >= 0),
);
go

create table Examinations
(
    ExaminationID int identity(1,1) not null primary key,
    ExaminationName nvarchar(100) not null unique check (ExaminationName <> ''),
);
go

create table Wards
(
    WardID int identity(1,1) not null primary key,
    WardName nvarchar(20) not null unique check (WardName <> ''),
    WardPlaces int not null check (WardPlaces >= 1),
    DepartmentID int not null foreign key references Departments(DepartmentID),
);


create table DoctorsExaminations
(
    DoctorsExaminationID int identity(1,1) not null primary key,
    DoctorsExaminationEndTime time not null,
    DoctorsExaminationStartTime time not null,
    check (DoctorsExaminationEndTime > DoctorsExaminationStartTime),
    DoctorID int not null foreign key references Doctors(DoctorID),
    ExaminationID int not null foreign key references Examinations(ExaminationID),
    WardID int not null foreign key references Wards(WardID),
)
    go

insert into Departments (DepartmentBuilding, DepartmentName) values
(1, 'Cardiology'),
(2, 'Neurology'),
(3, 'Oncology'),
(4, 'Traumatology'),
(5, 'Gynecology');
go

insert into Doctors (DoctorName, DoctorSurname, DoctorSalary, DoctorPremium) values
('John', 'Smith', 1000, 0),
('Jane', 'Doe', 1200, 200),
('Michael', 'Johnson', 1100, 0),
('Emily', 'Williams', 1300, 100),
('James', 'Brown', 1400, 500);
go

insert into Examinations (ExaminationName) values
('Blood test'),
('MRI'),
('X-ray'),
('Ultrasound'),
('CT');
go

insert into Wards (WardName, WardPlaces, DepartmentID) values
('Cardiology1', 10, 1),
('Cardiology2', 9, 1),
('Neurology1', 12, 2),
('Neurology2', 12, 2),
('Oncology1', 14, 3),
('Oncology2', 6, 3),
('Traumatology1', 4, 4),
('Traumatology2', 11, 4),
('Gynecology1', 9, 5),
('Gynecology2', 12, 5);
go

insert into DoctorsExaminations (DoctorsExaminationEndTime, DoctorsExaminationStartTime, DoctorID, ExaminationID, WardID) values
('12:00', '10:00', 1, 1, 1),
('14:00', '13:00', 2, 2, 2),
('16:00', '15:00', 3, 3, 3),
('18:00', '17:00', 4, 4, 4),
('20:00', '19:00', 5, 5, 5);
go

select * from Departments;
select * from Doctors;
select * from Examinations;
select * from Wards;
select * from DoctorsExaminations;

select count(*) as NumberOfWards from Wards where WardPlaces > 10;
go

select d.DepartmentName as BuildingName,
       count(w.WardID) as NumberOfWards
from Departments d
         join Wards W on d.DepartmentID = W.DepartmentID
group by d.DepartmentName;
go

select d.DepartmentName as DepartmentName,
       count(w.WardID) as NumberOfWards
from Departments d
         join Wards W on d.DepartmentID = W.DepartmentID
group by d.DepartmentName
    go

select d.DepartmentName as DepartmentName,
       sum(Doc.DoctorSalary + Doc.DoctorPremium) as TotalSalary
from Departments d
         join Wards W on d.DepartmentID = W.DepartmentID
         join DoctorsExaminations DE on W.WardID = DE.WardID
         join Doctors Doc on DE.DoctorID = Doc.DoctorID
group by d.DepartmentName;
go

select d.DepartmentName from Departments d
                                 join Wards W on d.DepartmentID = W.DepartmentID
                                 join DoctorsExaminations DE on W.WardID = DE.WardID
group by d.DepartmentName
having count(DE.DoctorID) >= 5;
go

select count(doc.DoctorID) as NumberOfDoctors, sum(doc.DoctorSalary + doc.DoctorPremium) as TotalSalary
from Doctors doc;
go

select avg(doc.DoctorSalary + doc.DoctorPremium) as AverageSalary
from Doctors doc;
go

select WardName from Wards
where WardPlaces = (select min(WardPlaces) from Wards);
go

select DepartmentBuilding from Departments d
                                   join Wards w on d.DepartmentID = w.DepartmentID
where w.WardPlaces > 10 and d.DepartmentBuilding in (1, 6, 7, 8)
group by d.DepartmentBuilding
having sum(w.WardPlaces) > 100;

drop table Departments;
drop table Doctors;
drop table Examinations;
drop table Wards;
drop table DoctorsExaminations;

use master;
drop database HospitalDB;