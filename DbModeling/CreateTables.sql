use QueensClassSchedule;
go 
create schema Udt;
create schema DbSecurity;
create schema Process;
create schema Udt;
Create schema Uploadfile;
create schema Project3;
-- go

CREATE TYPE [Udt].[SurrogateKeyInt] FROM [int] NULL
GO

CREATE TYPE [Udt].[DateAdded] FROM [datetime2] NOT NULL
GO

CREATE TYPE [Udt].[DateOfLastUpdate] FROM [datetime2] NOT NULL


CREATE TYPE [Udt].[ClassTime] FROM nchar(5) NOT NULL


CREATE TYPE [Udt].[IndividualProject] FROM nvarchar (60) NOT NULL


CREATE TYPE [Udt].[LastName] FROM nvarchar (35) NOT NULL

CREATE TYPE [Udt].[FirstName] FROM nvarchar(20) NOT NULL

CREATE TYPE [Udt].[GroupName] FROM nvarchar(20) NOT NULL;

/****** Object:  UserDefinedDataType [Udt].[BuildingLocation]    Script Date: 12/11/2020 2:39:53 AM ******/
CREATE TYPE [Udt].[BuildingLocation] FROM [nvarchar](50) NOT NULL
GO
/****** Object:  UserDefinedDataType [Udt].[ClassTime]    Script Date: 12/11/2020 2:39:53 AM ******/
CREATE TYPE [Udt].[ClassTime] FROM [nvarchar](50) NULL
GO
/****** Object:  UserDefinedDataType [Udt].[Count]    Script Date: 12/11/2020 2:39:53 AM ******/
CREATE TYPE [Udt].[Count] FROM [int] NULL
GO
/****** Object:  UserDefinedDataType [Udt].[CourseCode]    Script Date: 12/11/2020 2:39:53 AM ******/
CREATE TYPE [Udt].[CourseCode] FROM [varchar](50) NULL
GO
/****** Object:  UserDefinedDataType [Udt].[CourseDesc]    Script Date: 12/11/2020 2:39:53 AM ******/
CREATE TYPE [Udt].[CourseDesc] FROM [varchar](50) NULL
GO
/****** Object:  UserDefinedDataType [Udt].[CourseName]    Script Date: 12/11/2020 2:39:53 AM ******/
CREATE TYPE [Udt].[CourseName] FROM [varchar](50) NULL
GO
/****** Object:  UserDefinedDataType [Udt].[DateOf]    Script Date: 12/11/2020 2:39:53 AM ******/
CREATE TYPE [Udt].[DateOf] FROM [datetime2](7) NOT NULL
GO
/****** Object:  UserDefinedDataType [Udt].[DayOfWeek]    Script Date: 12/11/2020 2:39:53 AM ******/
CREATE TYPE [Udt].[DayOfWeek] FROM [nvarchar](50) NOT NULL
GO
/****** Object:  UserDefinedDataType [Udt].[DepartmentName]    Script Date: 12/11/2020 2:39:53 AM ******/
CREATE TYPE [Udt].[DepartmentName] FROM [nvarchar](50) NULL
GO
/****** Object:  UserDefinedDataType [Udt].[Description]    Script Date: 12/11/2020 2:39:53 AM ******/
CREATE TYPE [Udt].[Description] FROM [nvarchar](50) NOT NULL
GO
/****** Object:  UserDefinedDataType [Udt].[IndividualProject]    Script Date: 12/11/2020 2:39:53 AM ******/
CREATE TYPE [Udt].[IndividualProject] FROM [nvarchar](50) NULL
GO
/****** Object:  UserDefinedDataType [Udt].[IntValue]    Script Date: 12/11/2020 2:39:53 AM ******/
CREATE TYPE [Udt].[IntValue] FROM [nvarchar](50) NULL
GO
/****** Object:  UserDefinedDataType [Udt].[Location]    Script Date: 12/11/2020 2:39:53 AM ******/
CREATE TYPE [Udt].[Location] FROM [nvarchar](50) NULL
GO
/****** Object:  UserDefinedDataType [Udt].[ModeOfInstruction]    Script Date: 12/11/2020 2:39:53 AM ******/
CREATE TYPE [Udt].[ModeOfInstruction] FROM [nvarchar](50) NOT NULL
GO
/****** Object:  UserDefinedDataType [Udt].[Name]    Script Date: 12/11/2020 2:39:53 AM ******/
CREATE TYPE [Udt].[Name] FROM [nvarchar](50) NULL
GO
/****** Object:  UserDefinedDataType [Udt].[RoomLocation]    Script Date: 12/11/2020 2:39:53 AM ******/
CREATE TYPE [Udt].[RoomLocation] FROM [nvarchar](50) NOT NULL
GO
/****** Object:  UserDefinedDataType [Udt].[Section]    Script Date: 12/11/2020 2:39:53 AM ******/
CREATE TYPE [Udt].[Section] FROM [varchar](50) NULL
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE project3.QueensClassScheduleCurrentSemester(
	[Sec] [varchar](50) NULL,
	[Code] [varchar](50) NULL,
	[Course (hr, crd)] [varchar](50) NULL,
	[Description] [varchar](50) NULL,
	[Day] [varchar](50) NULL,
	[Time] [varchar](50) NULL,
	[Instructor] [varchar](50) NULL,
	[Location] [varchar](50) NULL,
	[Enrolled] [varchar](50) NULL,
	[Limit] [varchar](50) NULL,
	[Mode of Instruction] [varchar](50) NULL
) ON [PRIMARY]

insert into project3.QueensClassScheduleCurrentSemester(
       [Sec]
      ,[Code]
      ,[Course (hr, crd)]
      ,[Description]
      ,[Day]
      ,[Time]
      ,[Instructor]
      ,[Location]
      ,[Enrolled]
      ,[Limit]
      ,[Mode of Instruction] 
)
SELECT [Sec]
      ,[Code]
      ,[Course (hr, crd)]
      ,[Description]
      ,[Day]
      ,[Time]
      ,[Instructor]
      ,[Location]
      ,[Enrolled]
      ,[Limit]
      ,[Mode of Instruction]
from [Uploadfile].[CurrentSemesterCourseOfferings]




DROP TABLE IF EXISTS DbSecurity.UserAuthorization;
GO
CREATE TABLE DbSecurity.UserAuthorization
(
    UserAuthorizationKey INT identity(1,1) NOT NULL,
    ClassTime NCHAR(5) NULL
        DEFAULT ('10:45'),
    [Individual Project] NVARCHAR(60) NULL
        DEFAULT ('PROJECT 3 RECREATE THE BICLASS DATABASE STAR SCHEMA'),
    GroupMemberLastName NVARCHAR(35) NOT NULL,
    GroupMemberFirstName NVARCHAR(25) NOT NULL,
    GroupName NVARCHAR(20) NOT NULL,
    DateAdded DATETIME2 NULL
        DEFAULT SYSDATETIME()
        PRIMARY KEY CLUSTERED (UserAuthorizationKey ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
              ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
             ) ON [PRIMARY]
) ON [PRIMARY];
GO




if(object_id(N'[dbo].[RoomLocation]', 'U') is not null)
    DROP table [dbo].[RoomLocation];
CREATE TABLE [RoomLocation] (
	RoomLocationID int NOT NULL,
	RoomNumber [nvarchar](50) NULL,
    UserAuthorizationKey [Udt].[SurrogateKeyInt] NOT NULL,
    DateAdded [Udt].[DateAdded] not null default (sysdatetime()),
    DateOfLastUpdate [Udt].[DateOfLastUpdate]not null default (sysdatetime()),
  CONSTRAINT [PK_ROOMLOCATION] PRIMARY KEY CLUSTERED
  (
  [RoomLocationID] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)
)
GO


if(object_id(N'[dbo].[ModeInstruction]', 'U') is not null)
    DROP table [dbo].[ModeInstruction];
CREATE TABLE [dbo].[ModeInstruction] (
    [ModeID]               INT            IDENTITY (1, 1)           NOT NULL,
    [ModeName]             NVARCHAR (50)            NULL,
    [UserAuthorizationKey] [Udt].[SurrogateKeyInt]  NOT NULL,
    [DateAdded]            [Udt].[DateAdded]        DEFAULT (sysdatetime()) NOT NULL,
    [DateOfLastUpdate]     [Udt].[DateOfLastUpdate] DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [PK_MODEINSTRUCTION] PRIMARY KEY CLUSTERED ([ModeID] ASC),
    CONSTRAINT [ModeInstruction_fk0] FOREIGN KEY ([UserAuthorizationKey]) REFERENCES [DbSecurity].[UserAuthorization] ([UserAuthorizationKey]) ON UPDATE CASCADE
);

if(object_id(N'[dbo].[Course]', 'U') is not null)
    DROP table [dbo].[Course];
CREATE TABLE dbo.[Course] (
	CourseID int NOT NULL,
	CourseName varchar(30) NOT NULL,
	Description varchar(30) NOT NULL,
    [Credits]              NVARCHAR (50)            NOT NULL,
    [Hours]                NVARCHAR (50)            NOT NULL,
	DepartmentID int NOT NULL,
    UserAuthorizationKey [Udt].[SurrogateKeyInt] NOT NULL,
    DateAdded [Udt].[DateAdded] not null default (sysdatetime()),
    DateOfLastUpdate [Udt].[DateOfLastUpdate]not null default (sysdatetime()),
  CONSTRAINT [PK_COURSE] PRIMARY KEY CLUSTERED
  (
  [CourseID] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)

/****** Object:  Table [Process].[WorkflowSteps]    Script Date: 12/11/2020 2:39:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Process].[WorkflowSteps] (
    WorkFlowStepKey INT NOT NULL, -- primary key
    WorkFlowStepDescription NVARCHAR(50) NOT NULL,
    WorkFlowStepTableRowCount INT NULL DEFAULT(0),
    StartingDateTime DATETIME2(7) NULL DEFAULT (SYSDATETIME()) ,
    EndingDateTime DATETIME2(7) NULL DEFAULT (SYSDATETIME()) ,
    ClassTime CHAR(5) NULL DEFAULT ('10:45'),
    UserAuthorizationKey INT NOT NULL 
  CONSTRAINT [PK_WORKFLOWS] PRIMARY KEY CLUSTERED
  (
  [WorkFlowStepKey] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)
)
GO



if(object_id(N'[dbo].[Schedule]', 'U') is not null)
    DROP table [dbo].[Schedule];
CREATE TABLE [Schedule] (
	ScheduleID int IDENTITY(1,1) NOT NULL,
	SemesterID int NOT NULL,
	ClassID int NOT NULL,
    UserAuthorizationKey [Udt].[SurrogateKeyInt] NOT NULL,
    DateAdded [Udt].[DateAdded] not null default (sysdatetime()),
    DateOfLastUpdate [Udt].[DateOfLastUpdate]not null default (sysdatetime()),
  CONSTRAINT [PK_SCHEDULE] PRIMARY KEY CLUSTERED
  (
  [ScheduleID] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO


if(object_id(N'[dbo].[Instructor]', 'U') is not null)
    DROP table [dbo].[Instructor];
CREATE TABLE [Instructor] (
	InstructorID INT IDENTITY(1,1) NOT NULL,
	InstructorLastName varchar(30) NOT NULL,
	InstructorFirstName varchar(30) NOT NULL,
    UserAuthorizationKey [Udt].[SurrogateKeyInt] NOT NULL,
    DateAdded [Udt].[DateAdded] not null default (sysdatetime()),
    DateOfLastUpdate [Udt].[DateOfLastUpdate]not null default (sysdatetime()),
  CONSTRAINT [PK_INSTRUCTOR] PRIMARY KEY CLUSTERED
  (
  [InstructorID] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
if(object_id(N'[dbo].[Semester]', 'U') is not null)
    DROP table [dbo].[Semester];
CREATE TABLE [Semester] (
	SemesterID int IDENTITY(1,1) NOT NULL,
	SemesterName varchar(30) NULL,
    UserAuthorizationKey [Udt].[SurrogateKeyInt] NOT NULL,
    DateAdded [Udt].[DateAdded] not null default (sysdatetime()),
    DateOfLastUpdate [Udt].[DateOfLastUpdate]not null default (sysdatetime()),
  CONSTRAINT [PK_SEMESTER] PRIMARY KEY CLUSTERED
  (
  [SemesterID] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
if(object_id(N'[dbo].[ClassDetail]', 'U') is not null)
    DROP table [dbo].[ClassDetail];
CREATE TABLE [ClassDetail] (
	ClassDetailID int IDENTITY(1,1) NOT NULL,
    [Sec]                  NVARCHAR (50)            NOT NULL,
    [Code]                 NVARCHAR (50)            NOT NULL,
	Time varchar(255) NOT NULL,
	LocationID int NOT NULL,
	Enrolled int NOT NULL,
	MaxEnrollment int NOT NULL,
    UserAuthorizationKey [Udt].[SurrogateKeyInt] NOT NULL,
    DateAdded [Udt].[DateAdded] not null default (sysdatetime()),
    DateOfLastUpdate [Udt].[DateOfLastUpdate]not null default (sysdatetime()),
  CONSTRAINT [PK_CLASSDETAIL] PRIMARY KEY CLUSTERED
  (
  [ClassDetailID] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
if(object_id(N'[dbo].[Location]', 'U') is not null)
    DROP table [dbo].[Location];
CREATE TABLE [Location] (
	LocationID int IDENTITY(1,1) NOT NULL,
	RoomLocationID int NOT NULL,
	BuildingLocationID int NOT NULL,
    UserAuthorizationKey [Udt].[SurrogateKeyInt] NOT NULL,
    DateAdded [Udt].[DateAdded] not null default (sysdatetime()),
    DateOfLastUpdate [Udt].[DateOfLastUpdate]not null default (sysdatetime()),
  CONSTRAINT [PK_LOCATION] PRIMARY KEY CLUSTERED
  (
  [LocationID] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
if(object_id(N'[dbo].[Department]', 'U') is not null)
    DROP table [dbo].[Department];
CREATE TABLE [Department] (
	DepartmentId int IDENTITY(1,1) NOT NULL,
	DepartmentName varchar(30) NOT NULL,
    UserAuthorizationKey [Udt].[SurrogateKeyInt] NOT NULL,
    DateAdded [Udt].[DateAdded] not null default (sysdatetime()),
    DateOfLastUpdate [Udt].[DateOfLastUpdate]not null default (sysdatetime()),
  CONSTRAINT [PK_DEPARTMENT] PRIMARY KEY CLUSTERED
  (
  [DepartmentId] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO

GO
if(object_id(N'[dbo].[Class]', 'U') is not null)
    DROP table [dbo].[Class];
CREATE TABLE [Class] (
	ClassID int IDENTITY(1,1) NOT NULL,
	ClassDetailID int NOT NULL,
	InstructorID int NOT NULL,
	CourseID int NOT NULL,
	ModeId int NOT NULL,
    UserAuthorizationKey [Udt].[SurrogateKeyInt] NOT NULL,
    DateAdded [Udt].[DateAdded] not null default (sysdatetime()),
    DateOfLastUpdate [Udt].[DateOfLastUpdate]not null default (sysdatetime()),
  CONSTRAINT [PK_CLASS] PRIMARY KEY CLUSTERED
  (
  [ClassID] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
if(object_id(N'[dbo].[Day]', 'U') is not null)
    DROP table [dbo].[Day];
CREATE TABLE [Day] (
	DayID int IDENTITY(1,1) NOT NULL,
	DayName varchar(30) NOT NULL,
    UserAuthorizationKey [Udt].[SurrogateKeyInt] NOT NULL,
    DateAdded [Udt].[DateAdded] not null default (sysdatetime()),
    DateOfLastUpdate [Udt].[DateOfLastUpdate]not null default (sysdatetime()),
  CONSTRAINT [PK_DAY] PRIMARY KEY CLUSTERED
  (
  [DayID] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
if(object_id(N'[dbo].[ClassDay]', 'U') is not null)
    DROP table [dbo].[ClassDay];
CREATE TABLE [ClassDay] (
	ClassDayID int IDENTITY(1,1) NOT NULL,
	ClassDetailID int NOT NULL,
	DayID int NOT NULL,
    UserAuthorizationKey [Udt].[SurrogateKeyInt] NOT NULL,
    DateAdded [Udt].[DateAdded] not null default (sysdatetime()),
    DateOfLastUpdate [Udt].[DateOfLastUpdate]not null default (sysdatetime()),
  CONSTRAINT [PK_CLASSDAY] PRIMARY KEY CLUSTERED
  (
  [ClassDayID] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO
if(object_id(N'[dbo].[DepartmentInstructor]', 'U') is not null)
    DROP table [dbo].[DepartmentInstructor];
CREATE TABLE [DepartmentInstructor] (
	DeptInstructorID int IDENTITY(1,1) NOT NULL,
	InstrustorID int NOT NULL,
	DepartmentID int NOT NULL,
    UserAuthorizationKey [Udt].[SurrogateKeyInt] NOT NULL,
    DateAdded [Udt].[DateAdded] not null default (sysdatetime()),
    DateOfLastUpdate [Udt].[DateOfLastUpdate]not null default (sysdatetime()),
  CONSTRAINT [PK_DEPARTMENTINSTRUCTOR] PRIMARY KEY CLUSTERED
  (
  [DeptInstructorID] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)

)
GO


if(object_id(N'[dbo].[BuildingLocation]', 'U') is not null)
    DROP table [dbo].[BuildingLocation];
CREATE TABLE [BuildingLocation] (
	BuildingLocationID int IDENTITY(1,1) NOT NULL,
	BuildingName varchar(30) NOT NULL,
    UserAuthorizationKey [Udt].[SurrogateKeyInt] NOT NULL,
    DateAdded [Udt].[DateAdded] not null default (sysdatetime()),
    DateOfLastUpdate [Udt].[DateOfLastUpdate]not null default (sysdatetime()),
  CONSTRAINT [PK_BUILDINGLOCATION] PRIMARY KEY CLUSTERED
  (
  [BuildingLocationID] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)
)
GO


ALTER TABLE [Semester] WITH CHECK ADD CONSTRAINT [Semester_fk0] FOREIGN KEY ([UserAuthorizationKey]) REFERENCES [DbSecurity].[UserAuthorization]([UserAuthorizationKey])
ON UPDATE CASCADE
GO
ALTER TABLE [Semester] CHECK CONSTRAINT [Semester_fk0]
GO

ALTER TABLE [Instructor] WITH CHECK ADD CONSTRAINT [Instructor_fk0] FOREIGN KEY ([UserAuthorizationKey]) REFERENCES [DbSecurity].[UserAuthorization]([UserAuthorizationKey])
ON UPDATE CASCADE
GO
ALTER TABLE [Instructor] CHECK CONSTRAINT [Instructor_fk0]
GO

ALTER TABLE [Department] WITH CHECK ADD CONSTRAINT [Department_fk0] FOREIGN KEY ([UserAuthorizationKey]) REFERENCES [DbSecurity].[UserAuthorization]([UserAuthorizationKey])
ON UPDATE CASCADE
GO
ALTER TABLE [Department] CHECK CONSTRAINT [Department_fk0]
GO

ALTER TABLE [RoomLocation] WITH CHECK ADD CONSTRAINT [RoomLocation_fk0] FOREIGN KEY ([UserAuthorizationKey]) REFERENCES [DbSecurity].[UserAuthorization]([UserAuthorizationKey])
ON UPDATE CASCADE
GO
ALTER TABLE [RoomLocation] CHECK CONSTRAINT [RoomLocation_fk0]
GO

ALTER TABLE [BuildingLocation] WITH CHECK ADD CONSTRAINT [BuildingLocation_fk0] FOREIGN KEY ([UserAuthorizationKey]) REFERENCES [DbSecurity].[UserAuthorization]([UserAuthorizationKey])
ON UPDATE CASCADE
GO
ALTER TABLE [BuildingLocation] CHECK CONSTRAINT [BuildingLocation_fk0]
GO

ALTER TABLE [Day] WITH CHECK ADD CONSTRAINT [Day_fk0] FOREIGN KEY ([UserAuthorizationKey]) REFERENCES [DbSecurity].[UserAuthorization]([UserAuthorizationKey])
ON UPDATE CASCADE
GO
ALTER TABLE [Day] CHECK CONSTRAINT [Day_fk0]
GO



ALTER TABLE [ModeInstruction] WITH CHECK ADD CONSTRAINT [ModeInstruction_fk0] FOREIGN KEY ([UserAuthorizationKey]) REFERENCES [DbSecurity].[UserAuthorization]([UserAuthorizationKey])
ON UPDATE CASCADE
GO
ALTER TABLE [ModeInstruction] CHECK CONSTRAINT [ModeInstruction_fk0]
GO


ALTER TABLE [Schedule] WITH CHECK ADD CONSTRAINT [Schedule_fk0] FOREIGN KEY ([SemesterID]) REFERENCES [Semester]([SemesterID])
ON UPDATE CASCADE
GO
ALTER TABLE [Schedule] CHECK CONSTRAINT [Schedule_fk0]
GO
ALTER TABLE [Schedule] WITH CHECK ADD CONSTRAINT [Schedule_fk1] FOREIGN KEY ([ClassID]) REFERENCES [Class]([ClassID])
ON UPDATE CASCADE
GO
ALTER TABLE [Schedule] CHECK CONSTRAINT [Schedule_fk1]
GO
ALTER TABLE [Schedule] WITH CHECK ADD CONSTRAINT [Schedule_fk2] FOREIGN KEY ([UserAuthorizationKey]) REFERENCES [DbSecurity].[UserAuthorization]([UserAuthorizationKey])
ON UPDATE CASCADE
GO
ALTER TABLE [Schedule] CHECK CONSTRAINT [Schedule_fk2]
GO



ALTER TABLE [ClassDetail] WITH CHECK ADD CONSTRAINT [ClassDetail_fk0] FOREIGN KEY ([LocationID]) REFERENCES [Location]([LocationID])
ON UPDATE CASCADE
GO
ALTER TABLE [ClassDetail] CHECK CONSTRAINT [ClassDetail_fk0]
GO
ALTER TABLE [ClassDetail] WITH CHECK ADD CONSTRAINT [ClassDetail_fk1] FOREIGN KEY ([UserAuthorizationKey]) REFERENCES [DbSecurity].[UserAuthorization]([UserAuthorizationKey])
ON UPDATE CASCADE
GO
ALTER TABLE [ClassDetail] CHECK CONSTRAINT [ClassDetail_fk1]
GO

ALTER TABLE [Location] WITH CHECK ADD CONSTRAINT [Location_fk0] FOREIGN KEY ([RoomLocationID]) REFERENCES [RoomLocation]([RoomLocationID])
ON UPDATE CASCADE
GO
ALTER TABLE [Location] CHECK CONSTRAINT [Location_fk0]
GO
ALTER TABLE [Location] WITH CHECK ADD CONSTRAINT [Location_fk1] FOREIGN KEY ([BuildingLocationID]) REFERENCES [BuildingLocation]([BuildingLocationID])
ON UPDATE CASCADE
GO
ALTER TABLE [Location] CHECK CONSTRAINT [Location_fk1]
GO
ALTER TABLE [Location] WITH CHECK ADD CONSTRAINT [Location_fk2] FOREIGN KEY ([UserAuthorizationKey]) REFERENCES [DbSecurity].[UserAuthorization]([UserAuthorizationKey])
ON UPDATE CASCADE
GO
ALTER TABLE [Location] CHECK CONSTRAINT [Location_fk2]
GO


ALTER TABLE [Course] WITH CHECK ADD CONSTRAINT [Course_fk0] FOREIGN KEY ([DepartmentID]) REFERENCES [Department]([DepartmentId])
ON UPDATE CASCADE
GO
ALTER TABLE [Course] CHECK CONSTRAINT [Course_fk0]
GO
ALTER TABLE [Course] WITH CHECK ADD CONSTRAINT [Course_fk1] FOREIGN KEY ([UserAuthorizationKey]) REFERENCES [DbSecurity].[UserAuthorization]([UserAuthorizationKey])
ON UPDATE CASCADE
GO
ALTER TABLE [Course] CHECK CONSTRAINT [Course_fk1]
GO


ALTER TABLE [Class] WITH CHECK ADD CONSTRAINT [Class_fk0] FOREIGN KEY ([ClassDetailID]) REFERENCES [ClassDetail]([ClassDetailID])
ON UPDATE CASCADE
GO
ALTER TABLE [Class] CHECK CONSTRAINT [Class_fk0]
GO
ALTER TABLE [Class] WITH CHECK ADD CONSTRAINT [Class_fk1] FOREIGN KEY ([InstructorID]) REFERENCES [Instructor]([InstructorID])
ON UPDATE CASCADE
GO
ALTER TABLE [Class] CHECK CONSTRAINT [Class_fk1]
GO
ALTER TABLE [Class] WITH CHECK ADD CONSTRAINT [Class_fk2] FOREIGN KEY ([CourseID]) REFERENCES [Course]([CourseID])
ON UPDATE CASCADE
GO
ALTER TABLE [Class] CHECK CONSTRAINT [Class_fk2]
GO
ALTER TABLE [Class] WITH CHECK ADD CONSTRAINT [Class_fk3] FOREIGN KEY ([ModeId]) REFERENCES [ModeInstruction]([ModeID])
ON UPDATE CASCADE
GO
ALTER TABLE [Class] CHECK CONSTRAINT [Class_fk3]
GO
ALTER TABLE [Class] WITH CHECK ADD CONSTRAINT [Class_fk4] FOREIGN KEY ([UserAuthorizationKey]) REFERENCES [DbSecurity].[UserAuthorization]([UserAuthorizationKey])
ON UPDATE CASCADE
GO
ALTER TABLE [Class] CHECK CONSTRAINT [Class_fk4]
GO


ALTER TABLE [ClassDay] WITH CHECK ADD CONSTRAINT [ClassDay_fk0] FOREIGN KEY ([ClassDetainID]) REFERENCES [ClassDetail]([ClassDetailID])
ON UPDATE CASCADE
GO
ALTER TABLE [ClassDay] CHECK CONSTRAINT [ClassDay_fk0]
GO
ALTER TABLE [ClassDay] WITH CHECK ADD CONSTRAINT [ClassDay_fk1] FOREIGN KEY ([DayID]) REFERENCES [Day]([DayID])
ON UPDATE CASCADE
GO
ALTER TABLE [ClassDay] CHECK CONSTRAINT [ClassDay_fk1]
GO
ALTER TABLE [ClassDay] WITH CHECK ADD CONSTRAINT [ClassDay_fk2] FOREIGN KEY ([UserAuthorizationKey]) REFERENCES [DbSecurity].[UserAuthorization]([UserAuthorizationKey])
ON UPDATE CASCADE
GO
ALTER TABLE [ClassDay] CHECK CONSTRAINT [ClassDay_fk2]
GO

ALTER TABLE [DepartmentInstructor] WITH CHECK ADD CONSTRAINT [DepartmentInstructor_fk0] FOREIGN KEY ([InstrustorID]) REFERENCES [Instructor]([InstructorID])
ON UPDATE CASCADE
GO
ALTER TABLE [DepartmentInstructor] CHECK CONSTRAINT [DepartmentInstructor_fk0]
GO
ALTER TABLE [DepartmentInstructor] WITH CHECK ADD CONSTRAINT [DepartmentInstructor_fk1] FOREIGN KEY ([DepartmentID]) REFERENCES [Department]([DepartmentId])
ON UPDATE CASCADE
GO
ALTER TABLE [DepartmentInstructor] CHECK CONSTRAINT [DepartmentInstructor_fk1]
GO
ALTER TABLE [DepartmentInstructor] WITH CHECK ADD CONSTRAINT [DepartmentInstructor_fk2] FOREIGN KEY ([UserAuthorizationKey]) REFERENCES [DbSecurity].[UserAuthorization]([UserAuthorizationKey])
ON UPDATE CASCADE
GO
ALTER TABLE [DepartmentInstructor] CHECK CONSTRAINT [DepartmentInstructor_fk2]
GO

ALTER TABLE [Process].[WorkflowSteps] WITH CHECK ADD CONSTRAINT [WorkflowSteps_fk0] FOREIGN KEY ([UserAuthorizationKey]) REFERENCES [DbSecurity].[UserAuthorization]([UserAuthorizationKey])
ON UPDATE CASCADE
GO
ALTER TABLE [Process].[WorkflowSteps] CHECK CONSTRAINT [WorkflowSteps_fk0]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Semester]') AND type in (N'U'))
DROP TABLE [dbo].[Semester]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Schedule]') AND type in (N'U'))
DROP TABLE [dbo].[Schedule]
GO


-- =============================================
-- Author:		<Wenkai Tan>
-- Create date: <12/1/2022>
-- Description:	<Show Work Flow Steps>
-- =============================================
CREATE PROCEDURE [Process].[usp_ShowWorkflowSteps] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT *
	FROM [Process].[WorkFlowSteps];
END

GO
/****** Object:  StoredProcedure [Process].[usp_TrackWorkFlow]    Script Date: 12/11/2020 2:39:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Wenkai Tan>
-- Create date: <12/1/2022>
-- Description:	<Track Work Flow>
-- =============================================
CREATE PROCEDURE [Process].[usp_TrackWorkFlow]
    -- Add the parameters for the stored procedure here
    @WorkflowDescription [Udt].[Description],
    @WorkFlowStepTableRowCount [Udt].[Count],
    @StartingDateTime [Udt].[DateOf],
    @EndingDateTime [Udt].[DateOf],
    @UserAuthorizationKey [Udt].[SurrogateKeyInt]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
    INSERT INTO [Process].[WorkflowSteps]
    (
        WorkFlowStepDescription,
        WorkFlowStepTableRowCount,
        StartingDateTime,
        EndingDateTime,
        [ClassTime],
        UserAuthorizationKey
    )
    VALUES
    (@WorkflowDescription, @WorkFlowStepTableRowCount, @StartingDateTime, @EndingDateTime, '10:45',
     @UserAuthorizationKey);

END;



