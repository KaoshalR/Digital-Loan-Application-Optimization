-- ============================================================
-- Northstar Financial Services
-- SQL Analysis: Service Error Rate
-- ============================================================

-- Business Question:
-- Did service errors increase after the V2 release?

-- Hypothesis:
-- H7: V2 has a higher service-error rate than V1.

USE northstar;

SELECT
    a.release_version,

    COUNT(DISTINCT a.application_id) AS total_applications,

    COUNT(DISTINCT CASE
        WHEN e.event_type = 'Service Error'
        THEN a.application_id
    END) AS applications_with_service_error,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN e.event_type = 'Service Error'
            THEN a.application_id
        END)
        / COUNT(DISTINCT a.application_id) * 100,
        2
    ) AS service_error_rate

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
-- Applications with service error: 72
-- Service error rate: 3.60%
--
-- V2:
-- Total applications: 2,000
-- Applications with service error: 175
-- Service error rate: 8.75%
--
-- Change:
-- 8.75% - 3.60% = 5.15 percentage points
-- Relative increase ≈ 143.1%
--
-- INTERPRETATION:
-- The proportion of applications experiencing at least one
-- service error increased substantially after the V2 release.
--
-- This supports the hypothesis that V2 is associated with
-- increased service errors.
--
-- Further analysis is required to determine whether service
-- errors are associated with upload failures and abandonment.