-- ============================================================
-- Northstar Financial Services
-- SQL Analysis: Upload Duration by Release and Outcome
-- ============================================================

-- Business Question:
-- Did upload duration increase for both successful and
-- failed uploads after V2?

-- Hypothesis:
-- H10: Upload duration increased in V2 for both successful
-- and failed uploads.

USE northstar;

SELECT
    a.release_version,
    u.upload_status,

    COUNT(*) AS total_uploads,

    ROUND(
        AVG(
            TIMESTAMPDIFF(
                SECOND,
                u.start_time,
                u.end_time
            )
        ) / 60,
        2
    ) AS average_upload_duration_minutes,

    ROUND(
        MIN(
            TIMESTAMPDIFF(
                SECOND,
                u.start_time,
                u.end_time
            )
        ) / 60,
        2
    ) AS minimum_upload_duration_minutes,

    ROUND(
        MAX(
            TIMESTAMPDIFF(
                SECOND,
                u.start_time,
                u.end_time
            )
        ) / 60,
        2
    ) AS maximum_upload_duration_minutes

FROM uploads u

JOIN applications a
    ON u.application_id = a.application_id

WHERE u.start_time IS NOT NULL
  AND u.end_time IS NOT NULL

GROUP BY
    a.release_version,
    u.upload_status

ORDER BY
    a.release_version,
    u.upload_status;
    
    -- ============================================================
-- RESULT
-- ============================================================
--
-- V1 Successful:
-- 4,000 uploads
-- Average duration: 11.02 minutes
--
-- V2 Successful:
-- 6,000 uploads
-- Average duration: 21.11 minutes
--
-- Successful upload duration increased by:
-- 10.09 minutes
-- Approximately 91.6%
--
-- V1 Failed:
-- 385 uploads
-- Average duration: 12.18 minutes
--
-- V2 Failed:
-- 1,506 uploads
-- Average duration: 22.08 minutes
--
-- Failed upload duration increased by:
-- 9.90 minutes
-- Approximately 81.3%
--
-- INTERPRETATION:
-- Average upload duration increased substantially in V2
-- for both successful and failed uploads.
--
-- This indicates that the performance degradation affects
-- the broader upload process rather than being limited
-- to failed-upload handling.
--
-- This finding supports further investigation into
-- system/server performance, integrations, processing
-- capacity, or other technical changes introduced in V2.
--
-- The data does not by itself establish the specific
-- technical root cause.