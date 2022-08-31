// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import {KYCToken} from "../src/KYCToken.sol";

contract deployKYCToken is Script {
    function run() external {
        vm.startBroadcast();
        KYCToken token = new KYCToken();
        vm.stopBroadcast();
    }
}
