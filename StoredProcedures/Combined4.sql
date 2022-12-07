USe QueensClassSchedule


GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


DROP TABLE IF EXISTS Process.WorkflowSteps;
GO
CREATE TABLE Process.WorkflowSteps
(
    WorkFlowStepKey INT NOT NULL,
    WorkFlowStepsDescription NVARCHAR(100) NOT NULL,
    WorkFlowStepTableRowCount INT NULL,
    StartingDateTime DATETIME2(7) NULL,
    EndingDateTime DATETIME2(7) NULL,
    ClassTime nchar(5) Null Default '10:45',
    UserAuthorizationKey INT NOT NULL,
    PRIMARY KEY CLUSTERED (WorkFlowStepKey ASC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
          ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
         ) ON [PRIMARY]
);
GO



-- =============================================
-- Author:        <Wenkai Tan>
-- Create date: <12/1/2022>
-- Description:    <Show Work Flow Steps>
-- =============================================



DROP PROCEDURE IF EXISTS [Process].[usp_ShowWorkflowSteps];
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
/** Object:  StoredProcedure [Process].[usp_TrackWorkFlow]    Script Date: 12/11/2020 2:39:53 AM **/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        <Wenkai Tan>
-- Create date: <12/1/2022>
-- Description:    <Track Work Flow>
-- =============================================

DROP PROCEDURE IF EXISTS [Process].[usp_TrackWorkFlow];
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
-- DROP PROCEDURE IF EXISTS [Process].usp_TrackWorkFlow;
-- GO
-- CREATE PROCEDURE [Process].usp_TrackWorkFlow
--     @WorkFlowDescription NVARCHAR(100),
-- 	@StartDateTime DATETIME2,
-- 	@EndDateTime DATETIME2,
--     @WorkFlowTableRowCount INT,
--     @UserAuthorizationKey INT
-- AS
-- BEGIN
--     INSERT INTO [PROCESS].WorkFlowSteps
--     (
--         WorkFlowStepsDescription,
--         WorkFlowStepTableRowCount,
-- 		StartingDateTime,
-- 		EndingDateTime,
--         UserAuthorizationKey,
--         WorkFlowStepKey
--     )
--     VALUES
--     (@WorkFlowDescription, @WorkFlowTableRowCount, @StartDateTime, @EndDateTime, @UserAuthorizationKey,
--      NEXT VALUE FOR [PkSequence].[WorkflowStepsSequenceObject]);
-- END;
-- GO


-- DECLARE @StartDateTime DATETIME2 = SYSDATETIME()
-- DECLARE @EndDateTime DATETIME2 = SYSDATETIME()
-- EXEC Process.usp_TrackWorkFlow @WorkFlowDescription = N'Created usp_TrackWorkFlow', 
--                                @WorkFlowTableRowCount = 0, 
-- 							   @StartDateTime = @StartDateTime,
-- 							   @EndDateTime = @EndDateTime,
--                                @UserAuthorizationKey = 0   
-- GO 







SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DROP PROCEDURE IF EXISTS [Project3].[TruncateStarSchemaData];
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

    DELETE FROM  dbo.BuildingLocation;
    DELETE FROM dbo.Class;
    DELETE FROM dbo.ClassDay;
    DELETE FROM dbo.ClassDetail;
    DELETE FROM dbo.Course;
    DELETE FROM dbo.Day;
   DELETE FROM dbo.Department;
    DELETE FROM dbo.DepartmentInstructor;
    DELETE FROM dbo.Instructor;
    DELETE FROM dbo.Location;
    DELETE FROM dbo.ModeInstruction;
    DELETE FROM  dbo.RoomLocation;
   DELETE FROM  dbo.Schedule;
    --DELETE FROM  dbo.Semester; 

    ALTER SEQUENCE [PkSequence].[BuildingLocationSequenceObject] RESTART WITH 1;
    ALTER SEQUENCE [PkSequence].[ClassSequenceObject] RESTART WITH 1;
    ALTER SEQUENCE [PkSequence].[ClassDaySequenceObject] RESTART WITH 1;
    ALTER SEQUENCE [PkSequence].[ClassDetailSequenceObject] RESTART WITH 1;
    ALTER SEQUENCE [PkSequence].[CourseSequenceObject] RESTART WITH 1;
    ALTER SEQUENCE [PkSequence].[DaySequenceObject] RESTART WITH 1;
    ALTER SEQUENCE [PkSequence].[DepartmentSequenceObject] RESTART WITH 1;
    ALTER SEQUENCE [PkSequence].[DepartmentInstructorSequenceObject] RESTART WITH 1;
    ALTER SEQUENCE [PkSequence].[InstructionSequenceObject] RESTART WITH 1;
    ALTER SEQUENCE [PkSequence].[LocationSequenceObject] RESTART WITH 1;
    ALTER SEQUENCE [PkSequence].[ModeInstructionSequenceObject] RESTART WITH 1;
    ALTER SEQUENCE [PkSequence].[RoomLocationSequenceObject] RESTART WITH 1;
    ALTER SEQUENCE [PkSequence].[ScheduleSequenceObject] RESTART WITH 1;
    ALTER SEQUENCE [PkSequence].[SemesterSequenceObject] RESTART WITH 1;

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

-- EXEC [Project3].[TruncateStarSchemaData] @UserAuthorizationKey = 1; 

















DROP PROCEDURE IF EXISTS [Project3].[LoadStarSchemaData];
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


EXEC [Project3].[LoadStarSchemaData] @UserAuthorizationKey = 1;


-- EXEC [Process].[usp_ShowWorkflowSteps];