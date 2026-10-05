-- ============================================================
-- Northstar Financial Services
-- SQL Analysis: Service Error vs Abandonment
-- ============================================================

-- Business Question:
-- Are applications experiencing service errors more likely
-- to be abandoned?

-- Hypothesis:
-- H8: Applications with at least one service error have a
-- higher abandonment rate than applications without
-- a service error.

USE northstar;

SELECT
    CASE
        WHEN e.application_id IS NOT NULL
            THEN 'Had Service Error'
        ELSE 'No Service Error'
    END AS service_error_group,

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
    FROM system_events
    WHERE event_type = 'Service Error'
) e
    ON a.application_id = e.application_id

GROUP BY
    CASE
        WHEN e.application_id IS NOT NULL
            THEN 'Had Service Error'
        ELSE 'No Service Error'
    END;
    
    -- ============================================================
-- RESULT
-- ============================================================
--
-- No Service Error:
-- Applications: 3,753
-- Abandoned: 1,401
-- Completed: 2,352
-- Abandonment Rate: 37.33%
--
-- Had Service Error:
-- Applications: 247
-- Abandoned: 102
-- Completed: 145
-- Abandonment Rate: 41.30%
--
-- Difference:
-- 41.30% - 37.33% = 3.97 percentage points
-- Relative increase ≈ 10.6%
--
-- INTERPRETATION:
-- Applications experiencing at least one service error
-- had a higher abandonment rate than applications without
-- a service error.
--
-- This supports the hypothesis that service errors are
-- associated with increased abandonment.
--
-- The relationship is weaker than the observed relationship
-- between upload failures and abandonment.
-- Causation has not been established.
