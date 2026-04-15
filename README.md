# dune-analytics-queries-example

Example layout for [Dune Analytics](https://dune.com/) SQL: ad hoc queries grouped by chain or scope, ready to paste into the Dune query editor or to sync from git if you use Dune’s version control workflow.

This repository is a **template-style example**—swap in your own queries, naming, and folders as your work grows.

## Layout

```
queries/
├── cross_chain/   # Multi-chain or `evms.*` style queries
├── ethereum/      # Ethereum L1 (and L1-facing bridge metrics)
└── optimism/      # Optimism-specific tables and airdrops
```

## Queries

| File | Description |
|------|-------------|
| [`queries/ethereum/zksync_l1_bridge_wallet_nonce_distribution.sql`](queries/ethereum/zksync_l1_bridge_wallet_nonce_distribution.sql) | Wallet nonce buckets for successful ETH transfers to the zkSync Era L1 bridge contract. |
| [`queries/optimism/op_airdrop_4_eligible_claim_rate.sql`](queries/optimism/op_airdrop_4_eligible_claim_rate.sql) | OP Airdrop #4: distinct claimers vs eligible list (percentage). |
| [`queries/optimism/op_airdrop_4_claim_rate_by_op_amount.sql`](queries/optimism/op_airdrop_4_claim_rate_by_op_amount.sql) | OP-weighted claim rate (claimed vs total OP from allocation dataset). |
| [`queries/optimism/op_airdrop_4_claim_rate_by_address.sql`](queries/optimism/op_airdrop_4_claim_rate_by_address.sql) | Address-count claim rate (distinct claimed vs eligible addresses). |
| [`queries/cross_chain/cex_user_outflows_2024_mar_31.sql`](queries/cross_chain/cex_user_outflows_2024_mar_31.sql) | CEX-labeled sends (ETH + select stablecoins) on a fixed date window across several chains; excludes transfers to other labeled CEX addresses. |

## Usage

1. Open a `.sql` file and copy its contents into a new query on Dune.
2. Confirm **data source availability** for your plan (e.g. `dune.*` uploads, `labels.*`, `prices.*`, chain-specific schemas).
3. Adjust parameters (dates, contract addresses, filters) before relying on results in production dashboards.

## License

If you fork this example, add a license file that matches how you want others to use your queries.
