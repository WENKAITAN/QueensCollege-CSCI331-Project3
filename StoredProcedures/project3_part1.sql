USE [QueensClassSchedule]
GO

CREATE schema PkSequence;
create schema Udt;
create schema DbSecurity;
create schema Process;
create schema Udt;
Create schema Uploadfile;
create schema Project3;
DROP SEQUENCE IF EXISTS [PkSequence].[ClassDaySequenceObject];
CREATE SEQUENCE [PkSequence].[ClassDaySequenceObject]
AS [INT]
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 2147483647
CACHE;
GO
DROP SEQUENCE IF EXISTS [PkSequence].[ScheduleSequenceObject];
CREATE SEQUENCE [PkSequence].[ScheduleSequenceObject]
AS [INT]
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 2147483647
CACHE;

DROP SEQUENCE IF EXISTS [PkSequence].[ClassSequenceObject];
CREATE SEQUENCE [PkSequence].[ClassSequenceObject]
AS [INT]
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 2147483647
CACHE;
GO 

DROP SEQUENCE IF EXISTS [PkSequence].[ClassDaySequenceObject];
CREATE SEQUENCE [PkSequence].[ClassDaySequenceObject]
AS [INT]
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 2147483647
CACHE;
GO

DROP SEQUENCE IF EXISTS [PkSequence].[CourseSequenceObject];
CREATE SEQUENCE [PkSequence].[CourseSequenceObject]
AS [INT]
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 2147483647
CACHE;
GO

DROP SEQUENCE IF EXISTS [PkSequence].[ClassDetailSequenceObject];
CREATE SEQUENCE [PkSequence].[ClassDetailSequenceObject]
AS [INT]
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 2147483647
CACHE;
GO

DROP SEQUENCE IF EXISTS [PkSequence].[DaySequenceObject];
CREATE SEQUENCE [PkSequence].[DaySequenceObject]
AS [INT]
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 2147483647
CACHE;
GO


DROP SEQUENCE IF EXISTS [PkSequence].[UserAuthorizationSequenceObject];
CREATE SEQUENCE [PkSequence].[UserAuthorizationSequenceObject]
AS [INT]
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 2147483647
CACHE;
GO

DROP SEQUENCE IF EXISTS [PkSequence].[WorkflowStepsSequenceObject];
CREATE SEQUENCE [PkSequence].[WorkflowStepsSequenceObject]
AS [INT]
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 2147483647
CACHE;
GO

DROP SEQUENCE IF EXISTS [PkSequence].[ModeInstructionSequenceObject];
CREATE SEQUENCE [PkSequence].[ModeInstructionSequenceObject]
AS [INT]
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 2147483647
CACHE;
GO

DROP SEQUENCE IF EXISTS [PkSequence].[LocationSequenceObject];
CREATE SEQUENCE [PkSequence].[LocationSequenceObject]
AS [INT]
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 2147483647
CACHE;
GO

DROP SEQUENCE IF EXISTS [PkSequence].[BuildingLocationSequenceObject];
CREATE SEQUENCE [PkSequence].[BuildingLocationSequenceObject]
AS [INT]
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 2147483647
CACHE;
GO

DROP SEQUENCE IF EXISTS [PkSequence].[RoomLocationSequenceObject];
CREATE SEQUENCE [PkSequence].[RoomLocationSequenceObject]
AS [INT]
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 2147483647
CACHE;
GO

DROP SEQUENCE IF EXISTS PKSequence.DepartmentObject;
CREATE SEQUENCE PKSequence.DepartmentObject
AS [INT]
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 2147483647
CACHE;
GO


DROP SEQUENCE IF EXISTS PKSequence.DepartmentInstructorSequenceObject;
CREATE SEQUENCE PKSequence.DepartmentInstructorSequenceObject
AS [INT]
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 2147483647
CACHE;
GO

-- =============================================
DROP PROCEDURE IF EXISTS [Project3].[LoadDepartment]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Tao Hu

-- Description:   Loads data into dbo.Department 
--
-- =============================================
CREATE PROCEDURE [Project3].[LoadDepartment] @UserAuthorizationKey INT
AS
BEGIN

    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();
    SET NOCOUNT ON;

	DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();

	WITH Table1 AS
	(
	    SELECT DISTINCT SUBSTRING([Course (hr, crd)], 0, CHARINDEX(' ', [Course (hr, crd)])) AS DepartmentName
        FROM [QueensClassSchedule].[project3].[QueensClassScheduleCurrentSemester]

	) 

	INSERT INTO [QueensClassSchedule].[dbo].[Department]
	(
	    -- [DepartmentId],	
	    [DepartmentName],
	    [UserAuthorizationKey],
	    [DateAdded],
	    [DateOfLastUpdate]
	)
	SELECT 
	    -- NEXT VALUE FOR PKSequence.DepartmentObject, -- DepartmentId - SurrogateKey
		Table1.DepartmentName,
	    @UserAuthorizationKey, -- UserAuthorizationKey - SurrogateKey
	    SYSDATETIME(), -- DateAdded - Date_Time
	    SYSDATETIME() -- DateOfLastUpdate - Date_Time
	FROM Table1 



	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--if we need count row, comment this out
	--DECLARE @RowCount udt.WorkFlowStepTAbleRowCount;
    --SET @Rowcount = @@ROWCOUNT;


	DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();
    

    DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount =
    (
        SELECT count(*) FROM [QueensClassSchedule].[dbo].[Department]
    );

	-- we need this procedure to execute , name to be determined 
    EXEC Process.usp_TrackWorkFlow 'Load Department Table',
                                    --    @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
									   @WorkFlowTableRowCount = @WorkFlowTableRowCount, 
                                       @UserAuthorizationKey= 3;
END;
go

-- EXEC Project3.[LoadDepartment] @UserAuthorizationKey = 1;

-- =============================================
-- Author:		Tao Hu
-- Description:	Load data into [GroupNameProject3].Instructor
-- =============================================
DROP PROCEDURE IF EXISTS [Project3].[LoadInstructor]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project3].[LoadInstructor] @UserAuthorizationKey INT
AS
BEGIN


    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();
    SET NOCOUNT ON;

	DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();
    SET NOCOUNT ON;


	WITH C1 AS(

		SELECT
	    DISTINCT RIGHT([Instructor], LEN([Instructor]) - CHARINDEX(' ',[Instructor])) AS [First], -- InstructorFirstName - InstructorFirstName
	    SUBSTRING([Instructor],0,CHARINDEX(',',[Instructor])) AS [Last] -- InstructorLastName - InstructorLastName
		FROM [Uploadfile].[CurrentSemesterCourseOfferings] AS old
		WHERE 
			LEN(SUBSTRING([Instructor],0,CHARINDEX(',',[Instructor]))) > 0 
				AND 
		LEN(RIGHT([Instructor], LEN([Instructor]) - CHARINDEX(',',[Instructor])) ) > 0

	)
	INSERT INTO [QueensClassSchedule].[dbo].[Instructor]
	(
	    InstructorID, --InstructorId- SurrogateKey
	    InstructorLastName,
        InstructorFirstName,
	    UserAuthorizationKey,
	    DateAdded,
	    DateOfLastUpdate
	)

	SELECT
		NEXT VALUE FOR PKSequence.InstructorObject, -- InstructorId - SurrogateKey
        C1.[Last],
		C1.[First],
		@UserAuthorizationKey, -- UserAuthorizationKey - SurrogateKey
	    SYSDATETIME(), -- DateAdded - Date_Time
	    SYSDATETIME()  -- DateOfLastUpdate - Date_Time
	FROM C1


    DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount =
    (
        SELECT count(*) FROM [QueensClassSchedule].[dbo].[Instructor]
    )

   DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();
		--we need this procedure to execute , name to be determined 
    EXEC Process.usp_TrackWorkFlow 'Load Instructor Table',
                                    --    @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
									   @WorkFlowTableRowCount = @WorkFlowTableRowCount, 
                                       @UserAuthorizationKey = 6 ;

END

-- EXEC [Project3].[LoadInstructor] @UserAuthorizationKey = 1;
---------------------------------------------------------------------------------------
-- =============================================
-- Author:		Tao Hu
-- Description:	Load data into [Project3].LoadBuildingLocation;
-- =============================================
DROP PROCEDURE IF EXISTS [Project3].LoadBuildingLocation;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Project3].LoadBuildingLocation @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();

    INSERT INTO [dbo].BuildingLocation 
        (
        -- BuildingLocationID,
        BuildingName,
        UserAuthorizationKey,
        DateAdded,
        DateOfLastUpdate
    )
    
    SELECT 
        -- NEXT VALUE FOR PkSequence.BuildingLocationSequenceObject AS BuildingLocationID,
        o.BuildingName,
        @UserAuthorizationKey, 
        @DateAdded, 
        @DateOfLastUpdate 
    FROM 
        (SELECT DISTINCT 
            SUBSTRING(old.[Location], 0, CHARINDEX(' ', old.[Location])) AS BuildingName
        FROM Uploadfile.CurrentSemesterCourseOfferings AS OLD) AS O
    
    DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();

    DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount =
    (
        SELECT COUNT(*) FROM dbo.BuildingLocation
    );


    EXEC Process.usp_TrackWorkFlow  @WorkFlowDescription = N'Loads Building Location Data',             -- nvarchar(100)
	                                @StartDateTime = @StartingDateTime,                     -- datetime2(7)
	                                @EndDateTime = @EndingDateTime,                         -- datetime2(7)
	                                @WorkFlowTableRowCount = @WorkFlowTableRowCount,                    -- int
	                                @UserAuthorizationKey = 1                               -- int	 


END;
GO

-- EXEC [Project3].Load_BuildingLocation @UserAuthorizationKey =1;


---------------------------------------------------------------------------------------
-- =============================================
-- Author:		Tao Hu
-- Description:	Load data into [Project3].LoadRoomLocation;
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].LoadRoomLocation;
GO

CREATE PROCEDURE [Project3].LoadRoomLocation @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();

    INSERT INTO [dbo].RoomLocation (
        RoomLocationID,
        RoomNumber,
        UserAuthorizationKey,
        DateAdded,
        DateOfLastUpdate
    )
    SELECT 
        NEXT VALUE FOR PkSequence.RoomLocationSequenceObject AS RoomLocationID, 
        o.[RoomNumber],
        @UserAuthorizationKey, 
        @DateAdded, 
        @DateOfLastUpdate
    FROM 
        (SELECT DISTINCT 
            RIGHT(old.[Location], LEN(old.[Location]) - CHARINDEX(' ', old.[Location])) AS RoomNumber
        FROM Uploadfile.CurrentSemesterCourseOfferings AS OLD) AS O

    DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount =
    (
        SELECT COUNT(*) FROM dbo.RoomLocation
    );


    DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();

    EXEC Process.usp_TrackWorkFlow @WorkFlowDescription = N'Loads Room Location Data',             -- nvarchar(100)
                                    @WorkFlowTableRowCount = @WorkFlowTableRowCount,                    -- int
	                                @StartDateTime = @StartingDateTime,                     -- datetime2(7)
	                                @EndDateTime = @EndingDateTime,                         -- datetime2(7)
	                                
	                                @UserAuthorizationKey = 3                               -- int	 

END;
GO

-- EXEC [Project3].Load_RoomLocation @UserAuthorizationKey=1;
---------------------------------------------------------------------------------------
-- =============================================
-- Author:		Tao Hu
-- Description:	Load data into [Project3].[LoadModeInstruction] 
-- =============================================
DROP PROCEDURE IF EXISTS [Project3].[LoadModeInstruction] 
GO 

CREATE PROCEDURE [Project3].[LoadModeInstruction] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();

	INSERT INTO dbo.ModeInstruction (ModeName, UserAuthorizationKey, DateAdded, DateOfLastUpdate)
    select
        -- NEXT VALUE FOR PKSequence.[ModeInstructionSequenceObject],
        distinct a.[Mode Of Instruction], @UserAuthorizationKey, @DateAdded, @DateOfLastUpdate
    from [QueensClassSchedule].project3.QueensClassScheduleCurrentSemester as a
    DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();

    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount =
    (
        SELECT COUNT(*) FROM [Course].[ModeOfInstruction]
    );

    EXEC [Process].[usp_TrackWorkFlow] 'Loads data into [Course].[ModeInstruction]',
                                       @StartingDateTime,
                                       @EndingDateTime,
                                       @WorkFlowStepTableRowCount,
                                       @UserAuthorizationKey;
END;

-- EXEC [Project3].LoadModeInstruction @UserAuthorizationKey = 1;


-- =============================================
-- Author: Wenkai Tan
-- Description:	Load data into dbo.LoadDay
-- =============================================
DROP PROCEDURE IF EXISTS[Project3].[LoadDay];
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Project3].[LoadDay] @UserAuthorizationKey INT
AS
BEGIN


    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();
    SET NOCOUNT ON;

	DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();
    SET NOCOUNT ON;

    WITH c2 as(
        SELECT REPLACE([Day],' ','') as 'NewDay'
        FROM [QueensClassSchedule].project3.QueensClassScheduleCurrentSemester
    )
    INSERT INTO DBO.Day
    (
        DayName,
        UserAuthorizationKey,
	    DateAdded,
	    DateOfLastUpdate
    )

    SELECT 
    distinct 
        Case 
        WHEN [value] = 'SU' then 'SU'
        WHEN [value] = 'M' then 'M'
        WHEN [value] = 'TH' then 'TH'
        WHEN [value] = 'F' then 'F'
        WHEN [value] = 'W' then 'W'
        WHEN [value] = 'T' then 'T'
        WHEN [value] = 'S' then 'S'

        else 'TBD'
        end
    as 'DayName',
    @UserAuthorizationKey, -- UserAuthorizationKey - SurrogateKey
	SYSDATETIME(), -- DateAdded - Date_Time
	SYSDATETIME()  -- DateOfLastUpdate - Date_Time
    from c2 cross apply string_split(NewDay, ',')

	DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount = (
        select count(*) from dbo.Day
    );


	DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();
    DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();
		--we need this procedure to execute , name to be determined 
    EXEC Process.usp_TrackWorkFlow 'Load Instructor Table',
                                    --    @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
									   @WorkFlowTableRowCount, 
                                       @UserAuthorizationKey = 6 ;
END

-- EXEC [Project3].[LoadDay] @UserAuthorizationKey=1;

-- =============================================
-- Author: Wenkai Tan
-- Description:	Load data into dbo.LoadCourse
-- =============================================
DROP PROCEDURE IF EXISTS Project3.LoadCourse;
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE Project3.LoadCourse (@UserAuthorizationKey INT)
AS
BEGIN 
    DECLARE @Start DATETIME2 = SYSDATETIME()

    INSERT INTO dbo.Course
    (  
        CourseID, 
        CourseName, 
        Description, 
        Credits, 
        Hours, 
        DepartmentID,
        UserAuthorizationKey,
        DateAdded,
        DateOfLastUpdate
    )
    SELECT 
        NEXT VALUE FOR [PkSequence].[CourseSequenceObject],
        LEFT(o.[Course (hr, crd)],8) as 'CourseName',
        o.[Description],
        LEFT(RIGHT(o.[Course (hr, crd)], 2), 1) as 'Credits',
        LEFT(RIGHT(o.[Course (hr, crd)], 5), 1) as 'Hours',
        D.DepartmentID,
        @UserAuthorizationKey, -- UserAuthorizationKey - SurrogateKey
	    SYSDATETIME(), -- DateAdded - Date_Time
	    SYSDATETIME()  -- DateOfLastUpdate - Date_Time
    FROM project3.QueensClassScheduleCurrentSemester as o
    inner join dbo.Department as D on D.[DepartmentName] = LEFT(o.[Course (hr, crd)],4)
    
    DECLARE @End DATETIME2 = SYSDATETIME()

	DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount = (
        select count(*) from dbo.Course
    );


	DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();
    DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();
		--we need this procedure to execute , name to be determined 
    EXEC Process.usp_TrackWorkFlow 'Load Course Table',
                                    --    @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
									   @WorkFlowTableRowCount, 
                                       @UserAuthorizationKey = 6 ;
END
GO

-- exec Project3.LoadCourse @UserAuthorizationKey = 1 ;

-- RUN AFTER LOCATION

-- =============================================
-- Author: Wenkai Tan
-- Description:	Load data into dbo.ClassDetail
-- =============================================
DROP PROCEDURE IF EXISTS [Project3].[LoadClassDetail]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Project3].[LoadClassDetail] @UserAuthorizationKey INT
AS
BEGIN


    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();
    SET NOCOUNT ON;

	DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();
    SET NOCOUNT ON;

    ;with t1 as (
        select L.LocationID as 'LocationId', R.[RoomNumber], B.BuildingName
        from dbo.Location as L
        inner join dbo.RoomLocation as R on R.RoomLocationID = L.RoomLocationID
        inner join dbo.BuildingLocation as B on B.BuildingLocationID = L.BuildingLocationID
    )


    INSERT INTO dbo.ClassDetail
    (
        -- ClassDetailID, 
        Sec, 
        Code, 
        Time, 
        LocationID, 
        Enrolled, 
        MaxEnrollment,
        UserAuthorizationKey,
	    DateAdded,
	    DateOfLastUpdate
    )
    select 
        -- NEXT VALUE FOR [PkSequence].[ClassDetailSequenceObject] AS ClassDetailID,
        u.Sec, 
        u.Code, 
        u.Time, 
        T.LocationId, 
        u.Enrolled, 
        u.[Limit],
        @UserAuthorizationKey, -- UserAuthorizationKey - SurrogateKey
	    SYSDATETIME(), -- DateAdded - Date_Time
	    SYSDATETIME()  -- DateOfLastUpdate - Date_Time
    from [QueensClassSchedule].project3.QueensClassScheduleCurrentSemester as u 
    inner join [t1] as t 
    on u.Location = t.BuildingName + ' ' + t.RoomNumber;


	DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount = (
        select count(*) from dbo.ClassDetail
    );



   DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();
		--we need this procedure to execute , name to be determined 
    EXEC Process.usp_TrackWorkFlow 'Load ClassDetail Table',
                                    --    @WorkFlowStepTableRowCount,
                                       @StartingDateTime,
                                       @EndingDateTime,
									   @WorkFlowTableRowCount, 
                                       @UserAuthorizationKey = 6 ;
END

-- EXEC [Project3].[LoadClassDetail] @UserAuthorizationKey=1;


INSERT INTO DbSecurity.UserAuthorization
(
    UserAuthorizationKey,
    ClassTime,
    [Individual Project],
    GroupMemberLastName,
    GroupMemberFirstName,
    GroupName,
    DateAdded
)
VALUES
(   0,          -- UserAuthorizationKey - int
    DEFAULT,    -- ClassTime - nchar(5)
    DEFAULT,    -- Individual Project - nvarchar(60)
    N'Singh',  -- GroupMemberLastName - nvarchar(35)
    N'Amarjit', -- GroupMemberFirstName - nvarchar(25)
    N'Group-3',    -- GroupName - nvarchar(20)
    DEFAULT     -- DateAdded - datetime2(7)
    ),
(   1,          -- UserAuthorizationKey - int
    DEFAULT,    -- ClassTime - nchar(5)
    DEFAULT,    -- Individual Project - nvarchar(60)
    N'Tan', -- GroupMemberLastName - nvarchar(35)
    N'Wenkai',    -- GroupMemberFirstName - nvarchar(25)
    N'Group-3',    -- GroupName - nvarchar(20)
    DEFAULT     -- DateAdded - datetime2(7)
),
(   2,         -- UserAuthorizationKey - int
    DEFAULT,   -- ClassTime - nchar(5)
    DEFAULT,   -- Individual Project - nvarchar(60)
    N'Hu', -- GroupMemberLastName - nvarchar(35)
    N'Tao', -- GroupMemberFirstName - nvarchar(25)
    N'Group-3',   -- GroupName - nvarchar(20)
    DEFAULT    -- DateAdded - datetime2(7)
),
(   3,         -- UserAuthorizationKey - int
    DEFAULT,   -- ClassTime - nchar(5)
    DEFAULT,   -- Individual Project - nvarchar(60)
    N'Wangyal', -- GroupMemberLastName - nvarchar(35)
    N'Tenzin', -- GroupMemberFirstName - nvarchar(25)
    N'Group-3',   -- GroupName - nvarchar(20)
    DEFAULT    -- DateAdded - datetime2(7)
),
(   5,        -- UserAuthorizationKey - int
    DEFAULT,  -- ClassTime - nchar(5)
    DEFAULT,  -- Individual Project - nvarchar(60)
    N'Neill', -- GroupMemberLastName - nvarchar(35)
    N'Shane', -- GroupMemberFirstName - nvarchar(25)
    N'Group-3',  -- GroupName - nvarchar(20)
    DEFAULT   -- DateAdded - datetime2(7)
);
DECLARE @StartDateTime DATETIME2 = SYSDATETIME();
DECLARE @EndDateTime DATETIME2 = SYSDATETIME();

EXEC Process.usp_TrackWorkFlow @WorkFlowDescription = N'Added DbSecurity Values',
                               @WorkFlowStepTableRowCount = 0,
                               @StartingDateTime = @StartDateTime,
                               @EndingDateTime = @EndDateTime,
                               @UserAuthorizationKey = 0;
EXEC Process.usp_TrackWorkFlow @WorkFlowDescription = N'Added Schema',
                               @WorkFlowStepTableRowCount = 0,
                               @StartingDateTime = @StartDateTime,
                               @EndingDateTime = @EndDateTime,
                               @UserAuthorizationKey = 0;
EXEC Process.usp_TrackWorkFlow @WorkFlowDescription = N'Added Sequences',
                               @WorkFlowStepTableRowCount = 0,
                               @StartingDateTime = @StartDateTime,
                               @EndingDateTime = @EndDateTime,
                               @UserAuthorizationKey = 0;
EXEC Process.usp_TrackWorkFlow @WorkFlowDescription = N'Created DbSecurity.Authorization',
                               @WorkFlowStepTableRowCount = 0,
                               @StartingDateTime = @StartDateTime,
                               @EndingDateTime = @EndDateTime,
                               @UserAuthorizationKey = 0;
EXEC Process.usp_TrackWorkFlow @WorkFlowDescription = N'Created DimProductCategory',
                               @WorkFlowStepTableRowCount = 0,
                               @StartingDateTime = @StartDateTime,
                               @EndingDateTime = @EndDateTime,
                               @UserAuthorizationKey = 0;
EXEC Process.usp_TrackWorkFlow @WorkFlowDescription = N'Created DimProductSubcategory',
                               @WorkFlowStepTableRowCount = 0,
                               @StartingDateTime = @StartDateTime,
                               @EndingDateTime = @EndDateTime,
                               @UserAuthorizationKey = 0;
EXEC Process.usp_TrackWorkFlow @WorkFlowDescription = N'Created _usp.AnalysisWF',
                               @WorkFlowStepTableRowCount = 0,
                               @StartingDateTime = @StartDateTime,
                               @EndingDateTime = @EndDateTime,
                               @UserAuthorizationKey = 0;
GO




-- =============================================
-- Author:  Tao Hu
-- Description:   Loads data into dbo.DepartmentInstructorDetails
--
--
-- =============================================
DROP PROCEDURE IF EXISTS [Project3].[LoadDepartmentInstructor]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [Project3].[LoadDepartmentInstructor] @UserAuthorizationKey INT
	AS
BEGIN
    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();
    SET NOCOUNT ON;

	DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();
    SET NOCOUNT ON;

    WITH Table1 AS(

        SELECT
        DISTINCT d.DepartmentId as newDepartmentId, i.InstructorId as newInstructorId
        FROM [QueensClassSchedule].[dbo].[Instructor] as i,[QueensClassSchedule].[dbo].[Department] as d

    )
    INSERT INTO [QueensClassSchedule].[dbo].[DepartmentInstructor]
    (
      --   [DeptInstructorID]
     [InstrustorID]
      ,[DepartmentID]
      ,[UserAuthorizationKey]
      ,[DateAdded]
      ,[DateOfLastUpdate]
    )

    SELECT

       --  NEXT VALUE FOR PKSequence.DepartmentInstructorSequenceObject, 
        Table1.newDepartmentId,
        Table1.newInstructorId,
        @UserAuthorizationKey, -- UserAuthorizationKey - SurrogateKey
        SYSDATETIME(), -- DateAdded - Date_Time
        SYSDATETIME()  -- DateOfLastUpdate - Date_Time
    FROM Table1





	DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount = (
        select count(*) from dbo.DepartmentInstructor
    );



   DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();
		--we need this procedure to execute , name to be determined 
    EXEC Process.usp_TrackWorkFlow 'Load DepartmentInstructor Table',
                                       @StartingDateTime,
                                       @EndingDateTime,
									   @WorkFlowTableRowCount, 
                                       @UserAuthorizationKey = 6 ;

    /****** Script for SelectTopNRows command from SSMS  ******/
	--PRINT 'insert your statements within the Begin\End block which is the equivalentof the Java { \ }'

END

-- EXEC [Project3].[LoadDepartmentInstructor] @UserAuthorizationKey=1;
-- =============================================
-- Author:  Tao Hu
-- Description:   Loads data into dbo.Location
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].LoadLocation;
GO

CREATE PROCEDURE [Project3].LoadLocation @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();

    INSERT INTO [dbo].[Location] (
        -- LocationID,
        RoomLocationID,
        BuildingLocationID,
        UserAuthorizationKey,
        DateAdded,
        DateOfLastUpdate
    )
    SELECT 
        -- NEXT VALUE FOR PkSequence.LocationSequenceObject AS LocationID,
        b.[BuildingLocationID],
        r.[RoomLocationID],
        @UserAuthorizationKey, 
        @DateAdded, 
        @DateOfLastUpdate
    FROM Uploadfile.CurrentSemesterCourseOfferings AS O
        LEFT JOIN dbo.BuildingLocation AS B
            ON b.BuildingName = SUBSTRING(o.[Location], 0, CHARINDEX(' ', o.[Location])) 
        LEFT JOIN dbo.RoomLocation AS R 
            ON r.RoomNumber = RIGHT(o.[Location], LEN(o.[Location]) - CHARINDEX(' ', o.[Location]))  --RoomLocation  
    WHERE LEN(o.[Location]) > 0

	DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount = (
        select count(*) from dbo.Location
    );



   DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();
		--we need this procedure to execute , name to be determined 
    EXEC Process.usp_TrackWorkFlow 'Load Location Table',
                                       @StartingDateTime,
                                       @EndingDateTime,
									   @WorkFlowTableRowCount, 
                                       @UserAuthorizationKey = 6 ;

END;
GO

-- exec [Project3].LoadLocation @UserAuthorizationKey=1;

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:
-- Description:	Load data into dbo.ClassDay
--
--
-- ============================================


--------------------------------------------------------------------------------------------------------------


DROP PROCEDURE IF EXISTS [Project3].LoadClassDay;
GO

CREATE PROCEDURE [Project3].LoadClassDay @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();
    
    
    INSERT INTO [dbo].[ClassDay] (
        -- ClassDayID,
        ClassDetailID,
        DayID,
        UserAuthorizationKey,
        DateAdded,
        DateOfLastUpdate
    )

    SELECT 
        -- NEXT VALUE FOR PkSequence.ClassDaySequenceObject AS ClassDayID,
        cd.ClassDetailID,   --ClassDetail
        d.DayID,
        @UserAuthorizationKey, 
        @DateAdded, 
        @DateOfLastUpdate
    FROM Uploadfile.CurrentSemesterCourseOfferings AS O
        LEFT JOIN dbo.[ClassDetail] AS CD
            ON cd.Sec = o.Sec AND       --VARCHAR
               cd.Code = o.Code AND 
               cd.[Time] = o.[Time] AND 
               cd.Enrolled = o.Enrolled AND 
               cd.MaxEnrollment = o.Limit            --locationID
        LEFT JOIN dbo.[Day] AS D
            ON d.DayName = o.[Day]
        WHERE LEN(o.[Day]) > 0


    DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();

    DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount =
    (
        SELECT COUNT(*) FROM dbo.ClassDay
    );


	--we need this procedure to execute , name to be determined 
    EXEC Process.usp_TrackWorkFlow 'Load classday Table',
                                       @StartingDateTime,
                                       @EndingDateTime,
									   @WorkFlowTableRowCount, 
                                       @UserAuthorizationKey = 6 ;


END;
GO

-- exec [Project3].LoadClassDay @UserAuthorizationKey=1;
-- =============================================
-- Author:
-- Description:	Load data into dbo.ClassDay
--
--
-- ============================================




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].LoadClass;
GO

CREATE PROCEDURE [Project3].LoadClass @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;


WITH ClassCTE AS (
    SELECT cd.ClassDetailID, i.InstructorID, c.CourseID, mi.ModeID
    FROM project3.QueensClassScheduleCurrentSemester AS CS
    INNER JOIN dbo.Course AS C
        ON C.courseName + ' (' + C.Hours + ', ' + C.Credits + ')' = cs.[Course (hr, crd)]  AND
           C.Description = CS.Description
    INNER JOIN dbo.Instructor AS I
        ON i.InstructorLastName + ', ' + i.InstructorFirstName = cs.Instructor
    INNER JOIN dbo.ClassDetail AS CD
        ON cd.Sec = cs.Sec AND
           cd.Code = cs.Code AND
           cd.[Time] = cs.[Time] AND
           cd.Enrolled = cs.Enrolled AND
           cd.MaxEnrollment = cs.Limit
    INNER JOIN dbo.ModeInstruction AS MI 
        ON mi.ModeName = cs.[Mode of Instruction]
 )

INSERT INTO [dbo].[Class]
    (
        -- ClassID,
        ClassDetailID,
        InstructorId,
        CourseId, 
        ModeId,  
        UserAuthorizationKey,
        DateAdded,
        DateOfLastUpdate 
    )
SELECT
    -- NEXT VALUE FOR PkSequence.ClassSequenceObject AS ClassID,
    ClassCTE.ClassDetailID,
    ClassCTE.InstructorID,
    ClassCTE.CourseID,
    ClassCTE.ModeID,
    @UserAuthorizationKey, -- UserAuthorizationKey - SurrogateKey
	SYSDATETIME(), -- DateAdded - Date_Time
	SYSDATETIME()  -- DateOfLastUpdate - Date_Time
    FROM ClassCTE

    DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2
    SET @StartingDateTime = SYSDATETIME();

    DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount =
    (
        SELECT COUNT(*) FROM dbo.Class
    )


    EXEC Process.usp_TrackWorkFlow 'Load class Table',
                                       @StartingDateTime,
                                       @EndingDateTime,
									   @WorkFlowTableRowCount, 
                                       @UserAuthorizationKey = 6 ;


END;

-- EXEC [Project3].LoadClass @UserAuthorizationKey=1;

