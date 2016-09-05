/* TODO populate A/AS ids for sideloading? */
SELECT month, SUM(account_snapshots.value) AS total
FROM account_snapshots
GROUP BY month
