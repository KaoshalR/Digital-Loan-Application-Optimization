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