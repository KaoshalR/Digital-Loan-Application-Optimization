-- ============================================================
-- Northstar Financial Services
-- SQL Analysis: Session Timeout vs Abandonment
-- ============================================================

-- Business Question:
-- Are applications experiencing session timeouts more likely
-- to be abandoned?

-- Hypothesis:
-- H6: Applications with at least one session timeout have
-- a higher abandonment rate than applications without
-- a session timeout.

USE northstar;

SELECT
    CASE
        WHEN e.application_id IS NOT NULL
            THEN 'Had Session Timeout'
        ELSE 'No Session Timeout'
    END AS timeout_group,

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
    WHERE event_type = 'Session Timeout'
) e
    ON a.application_id = e.application_id

GROUP BY
    CASE
        WHEN e.application_id IS NOT NULL
            THEN 'Had Session Timeout'
        ELSE 'No Session Timeout'
    END;
    
    -- ============================================================
-- RESULT
-- ============================================================
--
-- No Session Timeout:
-- Applications: 3,589
-- Abandoned: 1,331
-- Completed: 2,258
-- Abandonment Rate: 37.09%
--
-- Had Session Timeout:
-- Applications: 411
-- Abandoned: 172
-- Completed: 239
-- Abandonment Rate: 41.85%
--
-- Difference:
-- 41.85% - 37.09% = 4.76 percentage points
-- Relative increase ≈ 12.8%
--
-- INTERPRETATION:
-- Applications experiencing at least one session timeout
-- had a higher abandonment rate than applications without
-- a session timeout.
--
-- This supports the hypothesis that session timeouts are
-- associated with increased abandonment.
--
-- The relationship is weaker than the observed relationship
-- between upload failures and abandonment. Causation has
-- not been established.