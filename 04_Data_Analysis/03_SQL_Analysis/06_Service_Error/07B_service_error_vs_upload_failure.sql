-- ============================================================
-- Northstar Financial Services
-- SQL Analysis: Service Error vs Upload Failure
-- ============================================================

-- Business Question:
-- Are applications experiencing service errors more likely
-- to experience failed uploads?

-- Hypothesis:
-- H7B: Applications with at least one service error have a
-- higher upload-failure rate than applications without
-- a service error.

USE northstar;

SELECT
    CASE
        WHEN e.application_id IS NOT NULL
            THEN 'Had Service Error'
        ELSE 'No Service Error'
    END AS service_error_group,

    COUNT(DISTINCT a.application_id) AS total_applications,

    COUNT(DISTINCT CASE
        WHEN u.upload_status = 'failed'
        THEN u.application_id
    END) AS applications_with_failed_upload,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN u.upload_status = 'failed'
            THEN u.application_id
        END)
        / COUNT(DISTINCT a.application_id) * 100,
        2
    ) AS upload_failure_rate

FROM applications a

LEFT JOIN (
    SELECT DISTINCT application_id
    FROM system_events
    WHERE event_type = 'Service Error'
) e
    ON a.application_id = e.application_id

LEFT JOIN uploads u
    ON a.application_id = u.application_id

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
-- Had Service Error:
-- Applications: 247
-- Applications with failed upload: 102
-- Upload failure rate: 41.30%
--
-- No Service Error:
-- Applications: 3,753
-- Applications with failed upload: 1,110
-- Upload failure rate: 29.58%
--
-- Difference:
-- 41.30% - 29.58% = 11.72 percentage points
-- Relative increase ≈ 39.6%
--
-- INTERPRETATION:
-- Applications experiencing at least one service error had
-- a higher upload-failure rate than applications without
-- a service error.
--
-- This supports the hypothesis that service errors are
-- associated with increased upload failures.
--
-- Causation has not been established.