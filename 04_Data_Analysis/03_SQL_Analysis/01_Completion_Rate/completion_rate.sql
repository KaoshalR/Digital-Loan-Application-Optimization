create database Northstar;
-- ============================================================
-- Northstar Financial Services
-- Digital Loan Application Optimization
-- SQL Analysis: V1 vs V2 Completion Rate
-- ============================================================

-- Business Question:
-- Did application completion decline after the V2 release?

-- Hypothesis:
-- H1: The V2 release is associated with a decline
-- in application completion.

USE northstar;

SELECT
    release_version,
    COUNT(application_id) AS total_applications,
    SUM(CASE
        WHEN status = 'Completed' THEN 1
        ELSE 0
    END) AS completed_applications,
    ROUND(
        SUM(CASE
            WHEN status = 'Completed' THEN 1
            ELSE 0
        END) / COUNT(application_id) * 100,
        2
    ) AS completion_rate
FROM applications
GROUP BY release_version
ORDER BY release_version;