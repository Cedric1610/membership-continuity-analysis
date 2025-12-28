-- =============================================
-- DATABASE SCHEMA SETUP (SIMULATE)
-- Project: Premium Membership Continuity Analysis
-- Description: Creates table structure and inserts synthetic test data, including edge cases.
-- =============================================

-- 1. Clean up ifit  exists
DROP TABLE IF EXISTS Raw_Member_Logs;

-- 2. Create Table
CREATE TABLE Raw_Member_Logs (
    Log_ID INT PRIMARY KEY,
    Customer_ID VARCHAR(10),
    Start_Datetime DATETIME,
    End_Datetime DATETIME,
    Status VARCHAR(20)
);

-- 3. Insert Synthetic Data (Designed to test specific logic scenarios)
INSERT INTO Raw_Member_Logs VALUES 
-- [SCENARIO A] Customer C001: Standard Continuity with Duplicates
-- Normal day
(1, 'C001', '2025-10-01 08:00:00', '2025-10-02 08:00:00', 'Active'),
-- Duplicate log (System error simulation) -> Should be handled by DISTINCT
(2, 'C001', '2025-10-01 09:30:00', '2025-10-02 09:30:00', 'Active'), 
-- Consecutive day
(3, 'C001', '2025-10-02 08:00:00', '2025-10-03 08:00:00', 'Active'),
-- Gap of 2 days (Membership expired, then renewed) -> Should start a NEW period
(4, 'C001', '2025-10-05 08:00:00', '2025-10-06 08:00:00', 'Payment_Failed'), -- Noise data
(5, 'C001', '2025-10-11 08:00:00', '2025-10-12 08:00:00', 'Active'),

-- [SCENARIO B] Customer C002: Cross-Month & Cross-Year Continuity
-- End of month transition (Oct 31 to Nov 01)
(6, 'C002', '2025-10-31 10:00:00', '2025-11-01 10:00:00', 'Active'),
(7, 'C002', '2025-11-01 10:00:00', '2025-11-02 10:00:00', 'Active'),
-- End of year transition (Dec 31 to Jan 01) -> Critical test for Date functions
(8, 'C002', '2025-12-31 23:00:00', '2026-01-01 23:00:00', 'Active'),
(9, 'C002', '2026-01-01 23:00:00', '2026-01-02 23:00:00', 'Active'),

-- [SCENARIO C] Customer C003: "Glitchy" User (Many failures mixed with success)
(10, 'C003', '2025-06-01 08:00:00', '2025-06-02 08:00:00', 'Payment_Failed'),
(11, 'C003', '2025-06-01 08:05:00', '2025-06-02 08:05:00', 'System_Error'),
-- Finally succeeded
(12, 'C003', '2025-06-01 09:00:00', '2025-06-02 09:00:00', 'Active'),
(13, 'C003', '2025-06-02 09:00:00', '2025-06-03 09:00:00', 'Active');
