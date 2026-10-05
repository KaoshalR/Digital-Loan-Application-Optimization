-- ============================================================
-- Northstar Financial Services
-- SQL Analysis: Upload Duration vs Session Timeout
-- ============================================================

-- Business Question:
-- Do applications experiencing session timeouts have
-- longer upload durations?

-- Hypothesis:
-- H5B: Applications with session timeouts have longer
-- average upload durations than applications without
-- session timeouts.

USE northstar;

SELECT
    CASE
        WHEN e.application_id IS NOT NULL
            THEN 'Had Session Timeout'
        ELSE 'No Session Timeout'
    END AS timeout_group,

    COUNT(DISTINCT a.application_id) AS total_applications,

    ROUND(
        AVG(
            TIMESTAMPDIFF(
                SECOND,
                u.start_time,
                u.end_time
            )
        ) / 60,
        2
    ) AS average_upload_duration_minutes

FROM applications a

JOIN uploads u
    ON a.application_id = u.application_id

LEFT JOIN (
    SELECT DISTINCT application_id
    FROM system_events
    WHERE event_type = 'Session Timeout'
) e
    ON a.application_id = e.application_id

WHERE u.start_time IS NOT NULL
  AND u.end_time IS NOT NULL

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
-- Had Session Timeout:
-- Applications: 411
-- Average upload duration: 19.86 minutes
--
-- No Session Timeout:
-- Applications: 3,589
-- Average upload duration: 17.26 minutes
--
-- Difference:
-- 19.86 - 17.26 = 2.60 minutes
-- Approximately 15.1% longer.
--
-- INTERPRETATION:
-- Applications experiencing session timeouts had longer
-- average upload durations than applications without
-- session timeouts.
--
-- This supports the hypothesis that longer upload durations
-- are associated with session timeouts.
--
-- This analysis does not establish causation.
-- Other factors such as server performance, service errors,
-- network conditions, or device type require further analysis.