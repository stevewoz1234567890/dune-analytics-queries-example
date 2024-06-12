WITH wallet_nonces AS (
  SELECT
    "from" AS wallet,
    MAX("nonce") AS max_nonce
  FROM
    ethereum.transactions
  WHERE
    "to" = 0x32400084C286CF3E17e7B677ea9583e60a000324
    AND "value" > 0
    AND "success"
  GROUP BY
    "from"
)

SELECT
  nonce_range,
  COUNT(*) AS wallet_count
FROM (
  SELECT
    CASE
      WHEN max_nonce >= 100 THEN '>=100 nonce: degen'
      WHEN max_nonce >= 10 AND max_nonce < 100 THEN '10~100 nonce: seasoned'
      ELSE '<10 nonce: newbie'
    END AS nonce_range
  FROM
    wallet_nonces
) AS nonce_ranges
GROUP BY
  nonce_range
ORDER BY
  wallet_count DESC;
