USE northstar;

SELECT
    a.release_version,
    u.error_code,
    COUNT(*) AS failed_uploads,

    ROUND(
        COUNT(*) /
        SUM(COUNT(*)) OVER (PARTITION BY a.release_version) * 100,
        2
    ) AS percentage_of_failed_uploads

FROM uploads u

JOIN applications a
    ON u.application_id = a.application_id

WHERE u.upload_status = 'failed'

GROUP BY
    a.release_version,
    u.error_code

ORDER BY
    a.release_version,
    failed_uploads DESC;
