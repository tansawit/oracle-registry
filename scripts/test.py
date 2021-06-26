from brownie import accounts, BandOracleProxy, ChainlinkOracleProxy, OracleRegistryBase


def main():
    acc = accounts.load("temp_deployer")
    chainlink_aggregator_registry_address = "0xfba6b9e493e1592229106F4c0F96Fd1A1Fee088d"
    token_registry_address = "0xAdb54199456C07B178F723F73938e726A67c71A7"
    stdrefproxy_address = "0xDA7a001b254CD22e46d3eAB04d937489c93174C3"

    comp_address = "0xc00e94cb662c3520282e6f5717214004a7f26888"
    usd_address = "0x0000000000000000000000000000000000000001"

    band_oracle_proxy = acc.deploy(BandOracleProxy, token_registry_address, stdrefproxy_address, publish_source=True)
    band_comp_price = band_oracle_proxy.getPrice(comp_address, usd_address) / 1e18
    print(f"Band Oracle COMP Price: {band_comp_price}")

    chainlink_oracle_proxy = acc.deploy(
        ChainlinkOracleProxy, chainlink_aggregator_registry_address, publish_source=True
    )
    chainlink_comp_price = chainlink_oracle_proxy.getPrice(comp_address, usd_address) / 1e18
    print(f"Chainlink Oracle COMP Price: {chainlink_comp_price}")

    oracle_registry_base = acc.deploy(
        OracleRegistryBase, band_oracle_proxy, chainlink_oracle_proxy, publish_source=True
    )
    band_comp_price_from_registry = oracle_registry_base.getOraclePrice(comp_address, usd_address, 0)
    print(f"Band Oracle COMP Price (form registry): {band_comp_price_from_registry}")
    chainlink_comp_price_from_registry = oracle_registry_base.getOraclePrice(comp_address, usd_address, 1)
    print(f"Chainlink Oracle COMP Price (form registry): {chainlink_comp_price_from_registry}")
