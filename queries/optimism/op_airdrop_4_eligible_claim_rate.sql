WITH total_eligible AS (
  SELECT COUNT(*) AS eligible_users
  FROM dune.oplabspbc.dataset_op_airdrop_4_simple_list
),

claimed AS (
  SELECT
    COUNT(DISTINCT r.to) AS claimed_users
  FROM erc20_optimism.evt_Transfer r
  INNER JOIN optimism.transactions t
    ON r.evt_tx_hash = t.hash
    AND r.evt_block_number = t.block_number
  WHERE contract_address = 0x4200000000000000000000000000000000000042
    AND r."from" = 0xfb4d5a94b516df77fbdbcf3cfeb262baaf7d4db7
)

SELECT claimed_users * 100.00 / (SELECT eligible_users FROM total_eligible) * 1.00 AS claim_rate
FROM claimed;
