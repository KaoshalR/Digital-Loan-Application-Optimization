USE northstar;

SELECT
    a.release_version,
    a.channel,

    COUNT(*) AS total_upload_attempts,

    SUM(
        CASE
            WHEN u.upload_status = 'failed'
            THEN 1
            ELSE 0
        END
    ) AS failed_uploads,

    SUM(
        CASE
            WHEN u.upload_status = 'successful'
            THEN 1
            ELSE 0
        END
    ) AS successful_uploads,

    ROUND(
        SUM(
            CASE
                WHEN u.upload_status = 'failed'
                THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS upload_failure_rate

FROM uploads u

JOIN applications a
    ON u.application_id = a.application_id

GROUP BY
    a.release_version,
    a.channel

ORDER BY
    a.release_version,
    a.channel;
    
    -- ============================================================
-- RESULT
-- ============================================================
--
-- V1 Mobile:
-- 2,521 attempts
-- 287 failed
-- 2,234 successful
-- Failure rate: 11.38%
--
-- V2 Mobile:
-- 4,335 attempts
-- 927 failed
-- 3,408 successful
-- Failure rate: 21.38%
--
-- Mobile change:
-- +10.00 percentage points
-- Approximately 87.9% relative increase
--
-- V1 Web:
-- 1,864 attempts
-- 98 failed
-- 1,766 successful
-- Failure rate: 5.26%
--
-- V2 Web:
-- 3,171 attempts
-- 579 failed
-- 2,592 successful
-- Failure rate: 18.26%
--
-- Web change:
-- +13.00 percentage points
-- Approximately 247.1% relative increase
--
-- INTERPRETATION:
-- Upload failure rates increased substantially on both
-- Mobile and Web following V2.
--
-- Mobile has the higher absolute failure rate in V2.
-- However, Web experienced the larger relative increase
-- compared with its V1 baseline.
--
-- The degradation is therefore not isolated to Mobile.
-- The data supports further investigation of broader
-- system/release-related factors.
--
-- This analysis does not establish the technical root cause.