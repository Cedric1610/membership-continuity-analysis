/* PROJECT: PREMIUM MEMBERSHIP CONTINUITY ANALYSIS (SIMULATED PROJECT)
Author: Thanh Do Quang
Tools Used: SQL (Window Functions, CTEs, Business Logic)
*/

WITH Raw_Cleaned AS (
    -- Step 1: Cast datetime to date, remove duplicates, filter only 'Active' status --
    SELECT DISTINCT 
        Customer_ID,
        CAST(Start_Datetime AS DATE) AS Start_Date, 
        CAST(End_Datetime AS DATE) AS End_Date
    FROM Raw_Member_Logs
    WHERE Status = 'Active' 
      AND Start_Datetime IS NOT NULL),
Separated_Points AS (
    -- Step 2: Find true start dates (not present in any End_Date column) --
    SELECT Start_Date AS Point_Date
    FROM Raw_Cleaned
    WHERE Start_Date NOT IN (SELECT End_Date FROM Raw_Cleaned)
    UNION ALL
    SELECT End_Date AS Point_Date
    FROM Raw_Cleaned
    WHERE End_Date NOT IN (SELECT Start_Date FROM Raw_Cleaned)
),
Paired_Periods AS (
    -- Step 3: Use LEAD to pair the current Start Date with the immediate next Date in the list
    SELECT Point_Date AS Membership_Start,
        LEAD(Point_Date, 1) OVER (ORDER BY Point_Date) AS Membership_End
    FROM Separated_Points
)
 -- Step 4: Finalize the answer
SELECT 
    Membership_Start,
    Membership_End,
    DATEDIFF(day, Membership_Start, Membership_End) AS Duration_Days,
    -- Business Logic: Double points if streak > 3 days
    CASE 
        WHEN DATEDIFF(day, Membership_Start, Membership_End) > 3 THEN DATEDIFF(day, Membership_Start, Membership_End) * 20
        ELSE DATEDIFF(day, Membership_Start, Membership_End) * 10 
    END AS Loyalty_Points_Earned
FROM Paired_Periods
WHERE Membership_Start IN (SELECT Start_Date FROM Raw_Cleaned)
ORDER BY Duration_Days DESC, Membership_Start;
