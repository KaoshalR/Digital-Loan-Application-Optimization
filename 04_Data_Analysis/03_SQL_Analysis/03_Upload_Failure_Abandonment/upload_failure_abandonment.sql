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
    
    -- ============================================================
-- RESULT
-- ============================================================
--
-- No Failed Upload:
-- Applications: 2,788
-- Abandoned: 959
-- Completed: 1,829
-- Abandonment Rate: 34.40%
--
-- Had Failed Upload:
-- Applications: 1,212
-- Abandoned: 544
-- Completed: 668
-- Abandonment Rate: 44.88%
--
-- Difference:
-- 44.88% - 34.40% = 10.48 percentage points
--
-- INTERPRETATION:
-- Applications experiencing at least one failed upload had
-- a higher abandonment rate than applications without failed
-- uploads.
--
-- This supports the hypothesis that upload failures are
-- associated with increased abandonment.
--
-- Causation has not been established.
-- Further analysis is required.
