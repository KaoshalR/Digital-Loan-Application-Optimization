-- ============================================================
-- Northstar Financial Services
-- SQL Analysis: Upload Duration by Release and Channel
-- ============================================================

-- Business Question:
-- Did V2 affect upload duration differently on Mobile vs Web?

-- Hypothesis:
-- H11A: The V2 upload-duration increase differs by channel.

USE northstar;

SELECT
    a.release_version,
    a.channel,

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
    a.channel

ORDER BY
    a.release_version,
    a.channel;
    
    -- ============================================================
-- RESULT
-- ============================================================
--
-- V1 Mobile:
-- 2,521 uploads
-- Average duration: 13.10 minutes
--
-- V2 Mobile:
-- 4,335 uploads
-- Average duration: 23.41 minutes
--
-- Mobile increase:
-- 10.31 minutes
-- Approximately 78.7%
--
-- V1 Web:
-- 1,864 uploads
-- Average duration: 8.45 minutes
--
-- V2 Web:
-- 3,171 uploads
-- Average duration: 18.43 minutes
--
-- Web increase:
-- 9.98 minutes
-- Approximately 118.1%
--
-- INTERPRETATION:
-- Upload duration increased substantially on both Mobile
-- and Web following the V2 release.
--
-- Therefore, the performance degradation is not isolated
-- to Mobile.
--
-- Mobile remains slower than Web in absolute upload duration,
-- but Web experienced the larger percentage increase from
-- its V1 baseline.
--
-- The analysis does not establish that either channel is
-- the root cause of the degradation.