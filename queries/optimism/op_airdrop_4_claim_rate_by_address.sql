WITH op_transfer AS (
  SELECT
    "to" AS address,
    evt_block_time AS claim_time,
    value / 1e18 AS op_received,
    op.price * (value / 1e18) AS op_received_usd
  FROM erc20_optimism.evt_Transfer tf
  LEFT JOIN prices.usd op
    ON op.minute = DATE_TRUNC('minute', evt_block_time)
    AND op.blockchain = 'optimism'
    AND op.contract_address = 0x4200000000000000000000000000000000000042
  WHERE "from" = 0xfb4d5a94b516df77fbdbcf3cfeb262baaf7d4db7
),

claim_stats AS (
  SELECT
    COUNT(DISTINCT ot.address) AS claimed_count,
    COUNT(DISTINCT a.address) AS total_count
  FROM op_transfer ot
  FULL OUTER JOIN dune.oplabspbc.dataset_op_airdrop_4_simple_list a
    ON ot.address = a.address
)

SELECT
  claimed_count,
  total_count,
  (claimed_count / CAST(total_count AS DECIMAL(18, 2))) * 100 AS claim_rate_percentage
FROM claim_stats;
