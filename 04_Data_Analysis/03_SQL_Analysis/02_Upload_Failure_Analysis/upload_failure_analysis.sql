-- ============================================================
-- Northstar Financial Services
-- Digital Loan Application Optimization
-- SQL Analysis: Upload Failure Rate
-- ============================================================

-- Business Question:
-- Did upload failures increase after the V2 release?

-- Hypothesis:
-- H2: V2 is associated with a higher upload failure rate.

USE northstar;

SELECT
    a.release_version,
    COUNT(u.upload_id) AS total_upload_attempts,

    SUM(
        CASE
            WHEN u.upload_status = 'Failed' THEN 1
            ELSE 0
        END
    ) AS failed_uploads,

    SUM(
        CASE
            WHEN u.upload_status = 'Successful' THEN 1
            ELSE 0
        END
    ) AS successful_uploads,

    ROUND(
        SUM(
            CASE
                WHEN u.upload_status = 'Failed' THEN 1
                ELSE 0
            END
        ) / COUNT(u.upload_id) * 100,
        2
    ) AS upload_failure_rate

FROM applications a

JOIN uploads u
    ON a.application_id = u.application_id

GROUP BY a.release_version
ORDER BY a.release_version;