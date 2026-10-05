-- ============================================================
-- Northstar Financial Services
-- SQL Analysis: Session Timeout Rate
-- ============================================================

-- Business Question:
-- Did session timeouts increase after the V2 release?

-- Hypothesis:
-- H5: V2 has a higher session timeout rate than V1.

USE northstar;

SELECT
    a.release_version,

    COUNT(DISTINCT a.application_id) AS total_applications,

    COUNT(DISTINCT CASE
        WHEN e.event_type = 'Session Timeout'
        THEN a.application_id
    END) AS timed_out_applications,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN e.event_type = 'Session Timeout'
            THEN a.application_id
        END)
        / COUNT(DISTINCT a.application_id) * 100,
        2
    ) AS session_timeout_rate

FROM applications a

LEFT JOIN system_events e
    ON a.application_id = e.application_id

GROUP BY a.release_version
ORDER BY a.release_version;

-- ============================================================
-- RESULT
-- ============================================================
--
-- V1:
-- Total applications: 2,000
-- Timed-out applications: 119
-- Session timeout rate: 5.95%
--
-- V2:
-- Total applications: 2,000
-- Timed-out applications: 292
-- Session timeout rate: 14.60%
--
-- Change:
-- 14.60% - 5.95% = 8.65 percentage points
--
-- INTERPRETATION:
-- Session timeout rate increased substantially after V2.
-- This supports the hypothesis that V2 is associated with
-- increased session timeouts.
--
-- Further analysis is required to determine whether the
-- increase in upload duration is associated with the
-- increased timeout rate.
