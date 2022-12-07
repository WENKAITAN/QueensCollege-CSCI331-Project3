CREATE SCHEMA Building_info;
GO

ALTER SCHEMA Building_info TRANSFER OBJECT::dbo.BuildingLocation;
GO

ALTER SCHEMA Building_info TRANSFER OBJECT::dbo.Location;
GO

ALTER SCHEMA Building_info TRANSFER OBJECT::dbo.Roomlocation;
GO

CREATE SCHEMA HR;
GO
ALTER SCHEMA HR TRANSFER OBJECT::Building_info.Instructor;
GO

ALTER SCHEMA HR TRANSFER OBJECT::Building_info.department;
GO

ALTER SCHEMA HR TRANSFER OBJECT::Building_info.departmentInstructor;
GO

CREATE SCHEMA Mode;
GO
ALTER SCHEMA Mode TRANSFER OBJECT::dbo.Modelinstruction;
GO

Create schema Course_info;
go

ALTER SCHEMA Course_info TRANSFER OBJECT::dbo.Class;
GO
ALTER SCHEMA Course_info TRANSFER OBJECT::dbo.Classday;
GO
ALTER SCHEMA Course_info TRANSFER OBJECT::dbo.Classdetail;
GO
ALTER SCHEMA Course_info TRANSFER OBJECT::dbo.course;
go


Create schema Attachment ;
go

ALTER SCHEMA Attachment  TRANSFER OBJECT::dbo.day;
GO
ALTER SCHEMA Attachment  TRANSFER OBJECT::dbo.ModeInstruction;
GO
ALTER SCHEMA Attachment  TRANSFER OBJECT::dbo.schedule;
GO