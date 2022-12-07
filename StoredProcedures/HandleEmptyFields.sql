USE QueensClassSchedule;

-- Fill Empty Spaces With TBA
UPDATE Project3.QueensClassScheduleCurrentSemester SET Day = 'TBA' WHERE LEN([Day]) < 1
UPDATE Project3.QueensClassScheduleCurrentSemester SET Time = 'TBA' WHERE Time = '-'
UPDATE Project3.QueensClassScheduleCurrentSemester SET Instructor = 'TBA' WHERE [Instructor] = ', '
UPDATE Project3.QueensClassScheduleCurrentSemester SET Location = 'TBA' WHERE LEN([Location]) < 1
