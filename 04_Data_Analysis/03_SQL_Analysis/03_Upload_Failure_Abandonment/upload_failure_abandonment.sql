-- ============================================================
-- Northstar Financial Services
-- Digital Loan Application Optimization
-- SQL Analysis: Upload Failure vs Abandonment
-- ============================================================

-- Business Question:
-- Are applications with failed uploads more likely to be abandoned?

-- Hypothesis:
-- H3: Applications experiencing one or more failed uploads
-- have a higher abandonment rate than applications without
-- failed uploads.

USE northstar;

SELECT
    CASE
        WHEN u.application_id IS NOT NULL
            THEN 'Had Failed Upload'
        ELSE 'No Failed Upload'
    END AS upload_failure_group,

    COUNT(a.application_id) AS total_applications,

    SUM(
        CASE
            WHEN a.status = 'Abandoned' THEN 1
            ELSE 0
        END
    ) AS abandoned_applications,

    SUM(
        CASE
            WHEN a.status = 'Completed' THEN 1
            ELSE 0
        END
    ) AS completed_applications,

    ROUND(
        SUM(
            CASE
                WHEN a.status = 'Abandoned' THEN 1
                ELSE 0
            END
        ) / COUNT(a.application_id) * 100,
        2
    ) AS abandonment_rate

FROM applications a

LEFT JOIN (
    SELECT DISTINCT application_id
    FROM uploads
    WHERE upload_status = 'Failed'
) u
    ON a.application_id = u.application_id

GROUP BY
    CASE
        WHEN u.application_id IS NOT NULL
            THEN 'Had Failed Upload'
        ELSE 'No Failed Upload'
    END;