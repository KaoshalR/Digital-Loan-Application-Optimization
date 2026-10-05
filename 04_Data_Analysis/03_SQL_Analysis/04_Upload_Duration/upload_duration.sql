-- ============================================================
-- Northstar Financial Services
-- Digital Loan Application Optimization
-- SQL Analysis: Upload Duration
-- ============================================================

-- Business Question:
-- Are uploads taking longer in V2 than in V1?

-- Hypothesis:
-- H4: Average upload duration increased after V2.

USE northstar;

SELECT
    a.release_version,

    COUNT(u.upload_id) AS total_uploads,

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

FROM applications a

JOIN uploads u
    ON a.application_id = u.application_id

WHERE u.start_time IS NOT NULL
  AND u.end_time IS NOT NULL

GROUP BY a.release_version
ORDER BY a.release_version;

-- ============================================================
-- RESULT
-- ============================================================
--
-- V1:
-- Total uploads: 4,385
-- Average duration: 11.12 minutes
-- Minimum: 2.00 minutes
-- Maximum: 32.33 minutes
--
-- V2:
-- Total uploads: 7,506
-- Average duration: 21.31 minutes
-- Minimum: 2.00 minutes
-- Maximum: 46.78 minutes
--
-- Change:
-- Average duration increased by 10.19 minutes.
-- Relative increase: 91.64%.
--
-- INTERPRETATION:
-- Average upload duration nearly doubled after the V2 release.
-- This supports the hypothesis that upload processing became
-- significantly slower after V2.
--
-- Further investigation is required to determine whether
-- longer uploads are contributing to session timeouts and
-- application abandonment.
