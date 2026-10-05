-- ============================================================
-- Northstar Financial Services
-- SQL Analysis: Upload Failure Type vs Upload Duration
-- ============================================================

-- Business Question:
-- Do different upload failure types have different
-- upload durations?

-- Hypothesis:
-- H9B: UPLOAD_TIMEOUT failures have a higher average
-- upload duration than other upload-failure types.

USE northstar;

SELECT
    u.error_code,

    COUNT(*) AS failed_uploads,

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

WHERE u.upload_status = 'failed'
  AND u.start_time IS NOT NULL
  AND u.end_time IS NOT NULL

GROUP BY u.error_code

ORDER BY average_upload_duration_minutes DESC;

-- ============================================================
-- RESULT
-- ============================================================
--
-- UPLOAD_TIMEOUT:
-- Failed uploads: 1,029
-- Average duration: 20.25 minutes
--
-- FILE_TOO_LARGE:
-- Failed uploads: 377
-- Average duration: 19.95 minutes
--
-- TRANSFER_ERROR:
-- Failed uploads: 485
-- Average duration: 19.78 minutes
--
-- BA INTERPRETATION:
-- UPLOAD_TIMEOUT has the highest average upload duration,
-- but the difference between failure types is small.
--
-- Therefore, failure type does not appear to be a strong
-- differentiator of upload duration.
--
-- The analysis does not establish that longer upload duration
-- specifically causes UPLOAD_TIMEOUT.
--
-- Further investigation is required to determine what changed
-- in V2 that caused the overall upload duration to increase.