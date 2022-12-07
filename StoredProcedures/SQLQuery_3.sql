USE QueensClassSchedule;


CREATE SCHEMA PkSequence;
CREATE SCHEMA Udt;
CREATE SCHEMA DbSecurity;
CREATE SCHEMA Process;
CREATE SCHEMA Udt;
CREATE SCHEMA Uploadfile;
CREATE SCHEMA Project3;


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Process].[usp_ShowWorkflowSteps]
GO

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



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Process].[usp_TrackWorkFlow]
GO

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
        WorkFlowStepsDescription,
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
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[Load_BuildingLocation]
GO

CREATE PROCEDURE [Project3].[Load_BuildingLocation] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();

    INSERT INTO [Building_Info].BuildingLocation 
        (
        BuildingName,
        UserAuthorizationKey,
        DateAdded,
        DateOfLastUpdate
    )
    
    SELECT 
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
        SELECT count(*) FROM [QueensClassSchedule].[Building_Info].BuildingLocation 
    );

	-- we need this procedure to execute , name to be determined 
	--set @WorkFlowStepsDescription = 'Load Department Table'
    EXEC Process.usp_TrackWorkFlow 'Load BuildingLocation Table',
                                    --    @WorkFlowStepTableRowCount,
                                       @StartingDateTime = @StartingDateTime,                     -- datetime2(7)
	                                @EndingDateTime = @EndingDateTime,                         -- datetime2(7)
	                                @WorkFlowStepTableRowCount = @WorkFlowTableRowCount,
                                       @UserAuthorizationKey= 3;
                               
END;
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[Load_RoomLocation]
GO

CREATE PROCEDURE [Project3].[Load_RoomLocation] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();
 
    INSERT INTO [Building_info].[RoomLocation] (
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

    DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();
    

    DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount =
    (
        SELECT count(*) FROM [QueensClassSchedule].[Building_info].[RoomLocation]
    );

    EXEC Process.usp_TrackWorkFlow 'Load RoomLocation Table',
                                    --    @WorkFlowStepTableRowCount,
                                       @StartingDateTime = @StartingDateTime,                     -- datetime2(7)
	                                @EndingDateTime = @EndingDateTime,                         -- datetime2(7)
	                                @WorkFlowStepTableRowCount = @WorkFlowTableRowCount,
                                       @UserAuthorizationKey= 3;

END;
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadClass]
GO

CREATE PROCEDURE [Project3].[LoadClass] @UserAuthorizationKey INT
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

INSERT INTO [Course_info].[Class]
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
        SELECT count(*) FROM [QueensClassSchedule].[Course_info].[Class]
    );

	-- we need this procedure to execute , name to be determined 
	--set @WorkFlowStepsDescription = 'Load Department Table'
    EXEC Process.usp_TrackWorkFlow 'Load Class Table',
                                    --    @WorkFlowStepTableRowCount,
                                       @StartingDateTime = @StartingDateTime,                     -- datetime2(7)
	                                @EndingDateTime = @EndingDateTime,                         -- datetime2(7)
	                                @WorkFlowStepTableRowCount = @WorkFlowTableRowCount,
                                       @UserAuthorizationKey= 3;

                                       

END;
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadClassDay]
GO

CREATE PROCEDURE [Project3].[LoadClassDay] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();
    
    
    INSERT INTO [Course_info].[ClassDay] (
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
        inner JOIN dbo.[ClassDetail] AS CD
            ON cd.Sec = o.Sec AND       --VARCHAR
               cd.Code = o.Code AND 
               cd.[Time] = o.[Time] AND 
               cd.Enrolled = o.Enrolled AND 
               cd.MaxEnrollment = o.Limit            --locationID
        inner JOIN dbo.[Day] AS D
            ON d.DayName = o.[Day]
        WHERE LEN(o.[Day]) > 0


    DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();

    DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount =
    (
        SELECT COUNT(*) FROM [QueensClassSchedule].[Course_info].[ClassDay]
    );

    EXEC Process.usp_TrackWorkFlow @WorkFlowDescription = N'Loads Class Day Data',             -- nvarchar(100)
	                                @StartDateTime = @StartingDateTime,                     -- datetime2(7)
	                                @EndDateTime = @EndingDateTime,                         -- datetime2(7)
	                                @WorkFlowTableRowCount = @WorkFlowTableRowCount,                    -- int
	                                @UserAuthorizationKey = 3                               -- int	 


END;
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadClassDetail]
GO

CREATE PROCEDURE [Project3].[LoadClassDetail] @UserAuthorizationKey INT
AS
BEGIN


    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();
    SET NOCOUNT ON;



    ;with t1 as (
        select L.LocationID as 'LocationId', R.[RoomNumber], B.BuildingName
        from dbo.Location as L
        inner join dbo.RoomLocation as R on R.RoomLocationID = L.RoomLocationID
        inner join dbo.BuildingLocation as B on B.BuildingLocationID = L.BuildingLocationID
    )


    INSERT INTO [Course_info].[ClassDetail]
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


    DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2
    SET @StartingDateTime = SYSDATETIME();



    DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount =
    (
        SELECT count(*) FROM [QueensClassSchedule].[Course_info].[ClassDetail]
    );

	-- we need this procedure to execute , name to be determined 
	--set @WorkFlowStepsDescription = 'Load Department Table'
    EXEC Process.usp_TrackWorkFlow 'Load ClassDetail Table',
                                    --    @WorkFlowStepTableRowCount,
                                       @StartingDateTime = @StartingDateTime,                     -- datetime2(7)
	                                @EndingDateTime = @EndingDateTime,                         -- datetime2(7)
	                                @WorkFlowStepTableRowCount = @WorkFlowTableRowCount,
                                       @UserAuthorizationKey= 3;

                                       

END;
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadCourse]
GO

CREATE PROCEDURE [Project3].[LoadCourse] (@UserAuthorizationKey INT)
AS
BEGIN 
    DECLARE @Start DATETIME2 = SYSDATETIME()

    INSERT INTO [Course_info].[Course]
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
    SET @WorkFlowTableRowCount =
    ( 
        SELECT COUNT(*) FROM [QueensClassSchedule].[Course_info].[Course]
    );
EXEC Process.usp_TrackWorkFlow @WorkFlowDescription = N'Loading ',  -- nvarchar(100)
                               @StartDateTime = @Start,       -- DateFormat
                               @EndDateTime = @End,         -- DateFormat
                               @WorkFlowTableRowCount = @WorkFlowTableRowCount,
                               @UserAuthorizationKey = 2

END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadDay]
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
    INSERT INTO [Attachment].[Day]
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

    DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();


    DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount =
    (
        SELECT count(*) FROM [QueensClassSchedule].[Attachment].[Day]
    );

	-- we need this procedure to execute , name to be determined 
	--set @WorkFlowStepsDescription = 'Load Department Table'
    EXEC Process.usp_TrackWorkFlow 'Load Day Table',
                                    --    @WorkFlowStepTableRowCount,
                                       @StartingDateTime = @StartingDateTime,                     -- datetime2(7)
	                                @EndingDateTime = @EndingDateTime,                         -- datetime2(7)
	                                @WorkFlowStepTableRowCount = @WorkFlowTableRowCount,
                                       @UserAuthorizationKey= 3;

                                       

END;
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadDepartment]
GO

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

	INSERT INTO [QueensClassSchedule].[HR].[Department]
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

	DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();
    

    DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount =
    (
        SELECT count(*) FROM [QueensClassSchedule].[HR].[Department]
    );

	-- we need this procedure to execute , name to be determined 
	--set @WorkFlowStepsDescription = 'Load Department Table'
    EXEC Process.usp_TrackWorkFlow 'Load Department Table',
                                    --    @WorkFlowStepTableRowCount,
                                       @StartingDateTime = @StartingDateTime,                     -- datetime2(7)
	                                @EndingDateTime = @EndingDateTime,                         -- datetime2(7)
	                                @WorkFlowStepTableRowCount = @WorkFlowTableRowCount,
                                       @UserAuthorizationKey= 3;

                                       
END;

--exec [Project3].[LoadDepartment] @UserAuthorizationKey =2
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadDepartmentInstructor]
GO

CREATE PROCEDURE [Project3].[LoadDepartmentInstructor] @UserAuthorizationKey INT
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
	    DISTINCT d.DepartmentId, i.InstructorId

		FROM project3.QueensClassScheduleCurrentSemester AS old
			INNER JOIN dbo.Department AS d
				ON SUBSTRING([Course (hr, crd)], 0, CHARINDEX(' ', [Course (hr, crd)])) = d.DepartmentName
			INNER JOIN dbo.Instructor AS i
				ON i.InstructorFirstName =RIGHT([Instructor], LEN([Instructor]) - CHARINDEX(' ',[Instructor]))
						AND
					i.InstructorLastName = SUBSTRING([Instructor],0,CHARINDEX(',',[Instructor])) 
		WHERE 
			LEN(SUBSTRING([Instructor],0,CHARINDEX(',',[Instructor]))) > 0 
				AND 
		LEN(RIGHT([Instructor], LEN([Instructor]) - CHARINDEX(',',[Instructor])) ) > 0

	)
	INSERT INTO [QueensClassSchedule].[HR].[DepartmentInstructor]
	(
        -- [DeptInstructorID]
      [DepartmentID]
      ,[InstrustorID]
      ,[UserAuthorizationKey]
      ,[DateAdded]
      ,[DateOfLastUpdate]
	)

	SELECT

		-- NEXT VALUE FOR PKSequence.DepartmentInstructorSequenceObject, 
		Table1.DepartmentId,
		Table1.InstructorId,
		@UserAuthorizationKey, -- UserAuthorizationKey - SurrogateKey
	    SYSDATETIME(), -- DateAdded - Date_Time
	    SYSDATETIME()  -- DateOfLastUpdate - Date_Time
	FROM Table1


DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();
    

    DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount =
    (
        SELECT count(*) FROM [QueensClassSchedule].[HR].[DepartmentInstructor]
    );

	-- we need this procedure to execute , name to be determined 
	--set @WorkFlowStepsDescription = 'Load Department Table'
    EXEC Process.usp_TrackWorkFlow 'Load DepartmentInstructor Table',
                                    --    @WorkFlowStepTableRowCount,
                                       @StartingDateTime = @StartingDateTime,                     -- datetime2(7)
	                                @EndingDateTime = @EndingDateTime,                         -- datetime2(7)
	                                @WorkFlowStepTableRowCount = @WorkFlowTableRowCount,
                                       @UserAuthorizationKey= 3;

                                       
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadInstructor]
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
	INSERT INTO [QueensClassSchedule].[HR].[Instructor]
	(
	    --InstructorID, --InstructorId- SurrogateKey
	    InstructorLastName,
        InstructorFirstName,
	    UserAuthorizationKey,
	    DateAdded,
	    DateOfLastUpdate
	)

	SELECT
		--NEXT VALUE FOR PKSequence.InstructorObject, -- InstructorId - SurrogateKey
        C1.[Last],
		C1.[First],
		@UserAuthorizationKey, -- UserAuthorizationKey - SurrogateKey
	    SYSDATETIME(), -- DateAdded - Date_Time
	    SYSDATETIME()  -- DateOfLastUpdate - Date_Time
	FROM C1


    DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();


    DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount =
    (
        SELECT count(*) FROM [QueensClassSchedule].[HR].[Instructor]
    );

	-- we need this procedure to execute , name to be determined 
	--set @WorkFlowStepsDescription = 'Load Department Table'
    EXEC Process.usp_TrackWorkFlow 'Load Instructor Table',
                                    --    @WorkFlowStepTableRowCount,
                                       @StartingDateTime = @StartingDateTime,                     -- datetime2(7)
	                                @EndingDateTime = @EndingDateTime,                         -- datetime2(7)
	                                @WorkFlowStepTableRowCount = @WorkFlowTableRowCount,
                                       @UserAuthorizationKey= 3;

                                       

END;

--EXEC [Project3].[LoadInstructor] @UserAuthorizationKey = 1;
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadLocation]
GO

CREATE PROCEDURE [Project3].[LoadLocation] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();

    INSERT INTO [Building_info].[Location] (
        --LocationID,
        BuildingLocationID,
        RoomLocationID,
        UserAuthorizationKey,
        DateAdded,
        DateOfLastUpdate
    )
    SELECT 
        --NEXT VALUE FOR PkSequence.LocationSequenceObject AS LocationID,
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

DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();
    

    DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount =
    (
        SELECT count(*) FROM [QueensClassSchedule].[Building_info].[Location]
    );

	-- we need this procedure to execute , name to be determined 
	--set @WorkFlowStepsDescription = 'Load Department Table'
    EXEC Process.usp_TrackWorkFlow 'Load Location Table',
                                    --    @WorkFlowStepTableRowCount,
                                       @StartingDateTime = @StartingDateTime,                     -- datetime2(7)
	                                @EndingDateTime = @EndingDateTime,                         -- datetime2(7)
	                                @WorkFlowStepTableRowCount = @WorkFlowTableRowCount,
                                       @UserAuthorizationKey= 3;

                                       

END;
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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

	INSERT INTO [Attachment].[ModeInstruction] (ModeName, UserAuthorizationKey, DateAdded, DateOfLastUpdate)
    select
        -- NEXT VALUE FOR PKSequence.[ModeInstructionSequenceObject],
        distinct a.[Mode Of Instruction], @UserAuthorizationKey, @DateAdded, @DateOfLastUpdate
    from [QueensClassSchedule].project3.QueensClassScheduleCurrentSemester as a
    DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();




    DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount =
    (
        SELECT count(*) FROM [QueensClassSchedule].[Attachment].[ModeInstruction]
    );

	-- we need this procedure to execute , name to be determined 
	--set @WorkFlowStepsDescription = 'Load Department Table'
    EXEC Process.usp_TrackWorkFlow 'Load ModeInstruction Table',
                                    --    @WorkFlowStepTableRowCount,
                                       @StartingDateTime = @StartingDateTime,                     -- datetime2(7)
	                                @EndingDateTime = @EndingDateTime,                         -- datetime2(7)
	                                @WorkFlowStepTableRowCount = @WorkFlowTableRowCount,
                                       @UserAuthorizationKey= 3;

                                       


END;
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadQueensCourseSchedule]
GO

CREATE PROCEDURE [Project3].[LoadQueensCourseSchedule] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DateAdded DATETIME2;
    SET @DateAdded = SYSDATETIME();

    DECLARE @DateOfLastUpdate DATETIME2;
    SET @DateOfLastUpdate = SYSDATETIME();

    DECLARE @StartingDateTime DATETIME2;
    SET @StartingDateTime = SYSDATETIME();

    INSERT INTO [Attachment].[Schedule] (
        ClassID,
        UserAuthorizationKey,
        DateAdded,
        DateOfLastUpdate
    )
    SELECT 
        --NEXT VALUE FOR PkSequence.LocationSequenceObject AS LocationID,
        ClassID,
        @UserAuthorizationKey, 
        @DateAdded, 
        @DateOfLastUpdate
    FROM dbo.Class;


    DECLARE @EndingDateTime DATETIME2;
    SET @EndingDateTime = SYSDATETIME();
    

    DECLARE @WorkFlowTableRowCount INT;
    SET @WorkFlowTableRowCount =
    (
        SELECT count(*) FROM [QueensClassSchedule].[Attachment].[Schedule]
    );



	-- we need this procedure to execute , name to be determined 
    EXEC Process.usp_TrackWorkFlow 'Load Schedule Table',
                                    --    @WorkFlowStepTableRowCount,
                                       @StartingDateTime = @StartingDateTime,                     -- datetime2(7)
	                                @EndingDateTime = @EndingDateTime,                         -- datetime2(7)
	                                @WorkFlowStepTableRowCount = @WorkFlowTableRowCount,
                                       @UserAuthorizationKey= 3;
END;
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[LoadStarSchemaData]
GO

CREATE PROCEDURE [Project3].[LoadStarSchemaData] @UserAuthorizationKey INT
AS
BEGIN
    SET NOCOUNT ON;
	    DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    --
    --	Drop All of the foreign keys prior to truncating tables in the star schema
 	--
  --  EXEC  [Project3].[DropForeignKeysFromStarSchemaData] @UserAuthorizationKey = 6;--change this number once groupmember AuthorizationKey confirmed
	--
	--	Check row count before truncation
	
	---EXEC[Project3].[ShowTableStatusRowCount] @UserAuthorizationKey = 2,  -- Change -1 to the appropriate UserAuthorizationKey
	--	@TableStatus = N'''Pre-truncate of tables'''
		
    --
    --	Always truncate the Star Schema Data
    --
   -- EXEC  [Project3].[TruncateStarSchemaData] @UserAuthorizationKey = 2;
	
    --
    --	Load the star schema
    --

    EXEC [Project3].[TruncateStarSchemaData] @UserAuthorizationKey = 1; 

    EXEC  [Project3].[Load_RoomLocation] @UserAuthorizationKey = 3;
    EXEC  [Project3].[Load_BuildingLocation] @UserAuthorizationKey = 2; 
    EXEC  [Project3].[LoadLocation] @UserAuthorizationKey = 2; 
    EXEC  [Project3].[LoadClassDetail] @UserAuthorizationKey = 2;  --ERROR
    EXEC  [Project3].[LoadDepartment] @UserAuthorizationKey = 2; 
    EXEC  [Project3].[LoadCourse] @UserAuthorizationKey = 3;
    EXEC  [Project3].[LoadDay] @UserAuthorizationKey = 2; 
    EXEC  [Project3].[LoadInstructor] @UserAuthorizationKey = 2; 
    EXEC  [Project3].[LoadDepartmentInstructor] @UserAuthorizationKey = 2;  -- Foreign key error 
    EXEC  [Project3].[LoadClassDay] @UserAuthorizationKey = 2;  -- Needs class detail

    EXEC  [Project3].[LoadModeInstruction] @UserAuthorizationKey = 2;     
    EXEC  [Project3].[LoadClass] @UserAuthorizationKey = 3; -- ERROR
    EXEC  [Project3].[LoadQueensCourseSchedule] @UserAuthorizationKey = 1; -- ERROR

	
    
	--	Check row count after truncation
	-- EXEC	[Project3].[ShowTableStatusRowCount]
	-- 	@UserAuthorizationKey = 2,  -- Change -1 to the appropriate UserAuthorizationKey
	-- 	@TableStatus = N'''Row Count after loading the star schema'''
	
    -- EXEC [Project3].[AddForeignKeysToStarSchemaData] @UserAuthorizationKey = 3;
    
	DECLARE @StartDateTime DATETIME2 = SYSDATETIME();
    DECLARE @EndDateTime DATETIME2 = SYSDATETIME();
    DECLARE @WorkFlowStepTableRowCount INT;

    SET @WorkFlowStepTableRowCount = 0;
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    EXEC Process.usp_TrackWorkFlow @WorkFlowDescription = N'Loading StarSchema',             -- nvarchar(100)
                                   @StartingDateTime = @StartDateTime, -- datetime2(7)
                                   @EndingDateTime = @EndDateTime,   -- datetime2(7)
                                   @WorkFlowStepTableRowCount = 0,             -- int
                                   @UserAuthorizationKey = 2               -- int
    
END;
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[TruncateStarSchemaData]
GO

CREATE  PROCEDURE [Project3].[TruncateStarSchemaData] @UserAuthorizationKey INT
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @StartingDateTime DATETIME2 = SYSDATETIME();

    -- TRUNCATE TABLE dbo.BuildingLocation;
    -- TRUNCATE TABLE dbo.Class;
    -- TRUNCATE TABLE dbo.ClassDay;
    -- TRUNCATE TABLE dbo.ClassDetail;
    -- TRUNCATE TABLE dbo.Course;
    -- TRUNCATE TABLE dbo.Day;
    -- TRUNCATE TABLE dbo.Department;
    -- TRUNCATE TABLE dbo.DepartmentInstructor;
    -- TRUNCATE TABLE dbo.Instruction;
    -- TRUNCATE TABLE dbo.Location;
    -- TRUNCATE TABLE dbo.ModeInstruction;
    -- TRUNCATE TABLE dbo.RoomLocation;
    -- TRUNCATE TABLE dbo.Schedule;
    -- TRUNCATE TABLE dbo.Semester;

    DELETE FROM [Building_info].[BuildingLocation];
    DELETE FROM [Course_info].[Class];
    DELETE FROM [Course_info].[ClassDay];
    DELETE FROM [Course_info].[ClassDetail];
    DELETE FROM [Course_info].[Course];
    DELETE FROM [Attachment].[Day];
    DELETE FROM [HR].[Department];
    DELETE FROM [HR].[DepartmentInstructor];
    DELETE FROM [HR].[Instructor];
    DELETE FROM [Building_info].[Location];
    DELETE FROM [Attachment].[ModeInstruction];
    DELETE FROM [Building_info].[RoomLocation];
   -- DELETE FROM  dbo.Schedule;
    --DELETE FROM  dbo.Semester; 

    -- ALTER SEQUENCE [PkSequence].[BuildingLocationSequenceObject] RESTART WITH 1;
    -- ALTER SEQUENCE [PkSequence].[ClassSequenceObject] RESTART WITH 1;
    -- ALTER SEQUENCE [PkSequence].[ClassDaySequenceObject] RESTART WITH 1;
    -- ALTER SEQUENCE [PkSequence].[ClassDetailSequenceObject] RESTART WITH 1;
    -- ALTER SEQUENCE [PkSequence].[CourseSequenceObject] RESTART WITH 1;
    -- ALTER SEQUENCE [PkSequence].[DaySequenceObject] RESTART WITH 1;
    -- ALTER SEQUENCE [PkSequence].[DepartmentSequenceObject] RESTART WITH 1;
    -- ALTER SEQUENCE [PkSequence].[DepartmentInstructorSequenceObject] RESTART WITH 1;
    -- ALTER SEQUENCE [PkSequence].[InstructionSequenceObject] RESTART WITH 1;
    -- ALTER SEQUENCE [PkSequence].[LocationSequenceObject] RESTART WITH 1;
    -- ALTER SEQUENCE [PkSequence].[ModeInstructionSequenceObject] RESTART WITH 1;
    -- ALTER SEQUENCE [PkSequence].[RoomLocationSequenceObject] RESTART WITH 1;
    -- ALTER SEQUENCE [PkSequence].[ScheduleSequenceObject] RESTART WITH 1;
    -- ALTER SEQUENCE [PkSequence].[SemesterSequenceObject] RESTART WITH 1;

	-- DECLARE @WorkFlowStepTableRowCount INT;
    -- SET @WorkFlowStepTableRowCount = 0;
    -- DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    -- EXEC Process.usp_TrackWorkFlow @WorkFlowDescription = N'Creation of truncation procedure',  -- nvarchar(100)
    --                                @StartDateTime = @StartingDateTime,                          -- datetime2(7)
    --                                @EndDateTime = @EndingDateTime,                              -- datetime2(7)
    --                                WorkFlowStepTableRowCount = 0,                                  -- int
    --                                @UserAuthorizationKey = 2                                    -- int

    DECLARE @StartDateTime DATETIME2 = SYSDATETIME();
    DECLARE @EndDateTime DATETIME2 = SYSDATETIME();
    DECLARE @WorkFlowStepTableRowCount INT;
    SET @WorkFlowStepTableRowCount = 0;
    DECLARE @EndingDateTime DATETIME2 = SYSDATETIME();
    EXEC Process.usp_TrackWorkFlow @WorkFlowDescription = N'Loading StarSchema',             -- nvarchar(100)
                                   @StartingDateTime = @StartDateTime, -- datetime2(7)
                                   @EndingDateTime = @EndDateTime,   -- datetime2(7)
                                   @WorkFlowStepTableRowCount = 0,             -- int
                                   @UserAuthorizationKey = 2               -- int
    
   
END;
GO
