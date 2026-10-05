SELECT
    release_version,
    channel,

    COUNT(application_id) AS total_applications,

    SUM(
        CASE
            WHEN status = 'completed'
            THEN 1
            ELSE 0
        END
    ) AS completed_applications,

    SUM(
        CASE
            WHEN status = 'abandoned'
            THEN 1
            ELSE 0
        END
    ) AS abandoned_applications,

    ROUND(
        SUM(
            CASE
                WHEN status = 'completed'
                THEN 1
                ELSE 0
            END
        ) / COUNT(application_id) * 100,
        2
    ) AS completion_rate

FROM applications

GROUP BY
    release_version,
    channel

ORDER BY
    release_version,
    channel;
    
    -- ============================================================
-- RESULT
-- ============================================================
--
-- V1 Mobile:
-- 1,117 applications
-- 785 completed
-- 332 abandoned
-- Completion rate: 70.28%
--
-- V2 Mobile:
-- 1,136 applications
-- 570 completed
-- 566 abandoned
-- Completion rate: 50.18%
--
-- Mobile change:
-- -20.10 percentage points
-- Relative decline ≈ 28.6%
--
-- V1 Web:
-- 883 applications
-- 654 completed
-- 229 abandoned
-- Completion rate: 74.07%
--
-- V2 Web:
-- 864 applications
-- 488 completed
-- 376 abandoned
-- Completion rate: 56.48%
--
-- Web change:
-- -17.59 percentage points
-- Relative decline ≈ 23.7%
--
-- INTERPRETATION:
-- Completion rates declined substantially on both Mobile
-- and Web following V2.
--
-- Mobile experienced the larger decline, but the issue
-- is not isolated to Mobile.
--
-- DATA VALIDATION NOTE:
-- The channel-level results produce an overall V1
-- completion rate of 71.95% and V2 completion rate of
-- 52.90%. This should be reconciled against the stated
-- business KPI of 72% to 54% before finalizing the KPI
-- baseline.