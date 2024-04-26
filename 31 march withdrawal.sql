WITH getCEXMapping as (
SELECT distinct address,name FROM (
select blockchain,address,name from labels.cex_ethereum
WHERE LOWER(name) LIKE '%okx%' OR LOWER(name) LIKE '%binance%' OR LOWER(name) LIKE '%coinbase%'
union all
select blockchain,address,name from labels.cex_optimism
WHERE LOWER(name) LIKE '%okx%' OR LOWER(name) LIKE '%binance%' OR LOWER(name) LIKE '%coinbase%'
union all
select blockchain,address,name from labels.cex_arbitrum
WHERE LOWER(name) LIKE '%okx%' OR LOWER(name) LIKE '%binance%' OR LOWER(name) LIKE '%coinbase%'
UNION ALL
select 'base',0x3304e22ddaa22bcdc5fca2269b418046ae7b566a,'Binance'
UNION ALL
select 'base',0xFd92F4e91d54B9EF91cc3f97C011a6aF0C2a7eDa,'OKX'
UNION ALL
select 'optimism',0xd1e859c8fbb8acdcc8e815c70d33b6aca58fde8a,'OKX'
UNION ALL
select 'base',0x5e809a85aa182a9921edd10a4163745bb3e36284,'Coinbase'
UNION ALL
select 'base',0x6d8675a52438849d90241cb639fba41bdc3329c8,'Coinbase'
UNION ALL
select 'base',0xe00d24c1f19b8737be269697282a2c371b3c18fd,'Coinbase'
UNION ALL
select 'base',0x66f43827d7e32ebd0a4c9f34305834da4227a14e,'Coinbase'
UNION ALL
select 'ethereum',0x27213e28d7fda5c57fe9e5dd923818dbccf71c47,'Coinbase'
UNION ALL
select 'ethereum',0xf52d01f94368d1695ab751d9595a59541e82c43c,'Coinbase'
UNION ALL
select 'ethereum',0x048757e80abbb6d4b6207b2146f1a65b3cb86630,'Coinbase'
UNION ALL
select 'ethereum',0x04abe732f966bb2ca59de3618388f9a84b04c0a3,'Coinbase'
UNION ALL
select 'ethereum',0xe9f2dcfdbb31149b02a520f8babd89227a0c6568,'Coinbase'
UNION ALL
select 'ethereum',0xa8298ef43c0cb7caa8fef567f284d2e2efbeee63,'Coinbase'
UNION ALL
select 'ethereum',0x40ebc1ac8d4fedd2e144b75fe9c0420be82750c6,'Coinbase'
UNION ALL
select 'ethereum',0xecc64e3f8126d270d6b4727614c77b18155f3253,'Binance'
UNION ALL
select 'ethereum',0x7ff84b2dd6154dcdf5969d2b8613a401bb7ebf23,'OKX'
UNION ALL
select 'ethereum',0xc9672d4427e7c6eb9a1bf67af719529bfd8b25e1,'OKX'
UNION ALL
select 'ethereum',0x7620dd50f99b998ab70e7cb8500ad536f20bb70c,'OKX'
UNION ALL
select 'ethereum',0xea171704994010004549907e0fd24aacaeae792f,'OKX'
) x
-- WHERE LOWER(name) NOT LIKE '%prime%'
),

mapping AS (
SELECT * FROM tokens.erc20
WHERE contract_address IN (0xff970a61a04b1ca14834a43f5de4533ebddb5cc8,
0xfd086bc7cd5c481dcc9c85ebe478a1c0b69fcbb9,
0xaf88d065e77c8cc2239327c5edb3a432268e5831,
0x833589fcd6edb6e08f4c7c32d4f71b54bda02913,
0xdac17f958d2ee523a2206206994597c13d831ec7,
0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48,
0x0b2c639c533813f4aa9d7837caf62653d097ff85,
0x7f5c764cbc14f9669b88837ca1490cca17c31607,
0x94b008aa00579c1307b0ef2c499ad98a8ce58e58)
)

SELECT 'ETH' as symbol,x.* FROM (
SELECT block_time,
       b.blockchain,
       "from" as sender_address,
       case when LOWER(name) LIKE '%binance%' THEN 'Binance'
            when LOWER(name) LIKE '%okx%' THEN 'OKX'
            when LOWER(name) LIKE '%coinbase%' THEN 'Coinbase'
            END as exchange_label,
       "to" as recipient_address,
       value/1e18 * price as amount_funded_usd,
       hash
FROM evms.transactions b JOIN getCEXMapping a ON address = "from" --and a.blockchain = b.blockchain
left join prices.usd q ON date_trunc('minute',block_time) = minute AND symbol = 'WETH' AND q.blockchain = 'ethereum'
WHERE block_time >= TIMESTAMP '2024-03-31' AND block_time < TIMESTAMP '2024-04-01'
AND data = 0x
AND b.blockchain IN ('ethereum','optimism','arbitrum','base')
AND value > 0
) x LEFT JOIN getCEXMapping ON recipient_address = address
WHERE name IS NULL
UNION ALL
SELECT symbol,
       block_time,
       blockchain,
       sender_address,
       case when LOWER(x.name) LIKE '%binance%' THEN 'Binance'
            when LOWER(x.name) LIKE '%okx%' THEN 'OKX'
            when LOWER(x.name) LIKE '%coinbase%' THEN 'Coinbase'
            END as exchange_label,
       recipient_address,
       amount_funded_usd,
       hash
FROM (
SELECT block_time,symbol,a.blockchain,a."from" as sender_address,name,c."to" as recipient_address,c.value/1e6 as amount_funded_usd,hash,data
from evms.transactions a 
JOIN mapping b ON "to" = contract_address and a.blockchain = b.blockchain
JOIN evms.erc20_transfers c ON a.block_number = c.evt_block_number and a.hash = c.evt_tx_hash
JOIN getCEXMapping d ON a."from" = d.address
WHERE block_time >= TIMESTAMP '2024-03-31' AND block_time < TIMESTAMP '2024-04-01'
) x LEFT JOIN getCEXMapping tt ON recipient_address = address
WHERE tt.name IS NULL