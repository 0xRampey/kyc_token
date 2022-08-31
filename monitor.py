from web3 import Web3
import asyncio
import json

provider = Web3.HTTPProvider("http://127.0.0.1:8545")
web3 = Web3(provider)

# this contract has been deployed on the rinkeby net
contract_address = Web3.toChecksumAddress(
    '0x05aa229aec102f78ce0e852a812a388f076aa555')

with open("out/KYCToken.sol/KYCToken.json") as f:
    info_json = json.load(f)
abi = info_json["abi"]

contract = web3.eth.contract(address=contract_address, abi=abi)


def handle_event(event):
    print(f"Event: {event['event']}\n")
    print(f"Data: {event['args']}\n")


async def log_loop(event_filter, poll_interval):
    while True:
        for event in event_filter.get_new_entries():
            handle_event(event)
        await asyncio.sleep(poll_interval)


def main():

    kyc_listener = contract.events.KYC.createFilter(fromBlock='latest')
    transfer_listener = contract.events.Transfer.createFilter(
        fromBlock='latest')
    approval_listener = contract.events.Approval.createFilter(
        fromBlock='latest')
    # block_filter = web3.eth.filter('latest')
    # tx_filter = web3.eth.filter('pending')
    loop = asyncio.get_event_loop()
    try:
        loop.run_until_complete(
            asyncio.gather(
                log_loop(kyc_listener, 2),
                log_loop(transfer_listener, 2),
                log_loop(approval_listener, 2)))
        # log_loop(block_filter, 2),
        # log_loop(tx_filter, 2)))
    finally:
        loop.close()


if __name__ == "__main__":
    main()
