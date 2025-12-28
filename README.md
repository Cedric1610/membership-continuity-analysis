# 🛒 E-commerce Membership Continuity Analysis

## 📌 Project Overview
In subscription-based businesses, tracking **Membership Continuity** is critical for calculating Customer Lifetime Value (CLV). Raw logs are often fragmented, containing duplicates, cross-year transitions, and error statuses.

This project uses **Advanced SQL** to transform messy raw logs into clean subscription periods.

## 🛠️ Tech Stack
* **Database:** MySQL 8.0+
* **Techniques:** CTEs, Window Functions (`LEAD`), Data Cleaning, Business Logic.

## 📊 Dataset & Scenarios
The dataset (`1_schema_setup.sql`) is synthesized to test 3 critical edge cases found in real-world logs:
* **Scenario A (Duplicates):** System creates multiple logs for the same day (e.g., Customer `C001`).
* **Scenario B (Time Transition):** Subscriptions crossing months or years (e.g., `Dec 31` to `Jan 01`).
* **Scenario C (Payment Failures):** Intermittent `Payment_Failed` logs mixed with `Active` status.

## 💡 Solution Logic (`2_solution_analysis.sql`)
The query follows a robust pipeline that handles all the above scenarios automatically:
1.  **Pre-processing:** Cleans duplicates and filters `Status != 'Active'`.
2.  **Boundary Identification:** Finds true start/end dates using Set Theory logic.
3.  **Period Pairing:** Uses `LEAD()` to map each Start Date to its End Date.
4.  **Metric Calculation:** Computes `Loyalty_Points` based on continuous streak duration.

## 🚀 How to Run
1.  Run `1_schema_setup.sql` to initialize the environment with test scenarios.
2.  Run `2_solution_analysis.sql` to see the transformed results.

## 📚 Technical Origin & Inspiration
This project is an extended, real-world adaptation of the famous **"Gaps and Islands"** problem (often seen in technical challenges like *HackerRank's SQL Project Planning*).

While the original challenge focuses on abstract integers, this project:
1.  **Contextualizes** the algorithm for E-commerce Membership data.
2.  **Enhances** complexity with Dirty Data handling (duplicates, cross-year dates).
3.  **Adds** Business Logic (Loyalty Points calculation).

---
*Author: Thanh Do Quang (Cedric)*
