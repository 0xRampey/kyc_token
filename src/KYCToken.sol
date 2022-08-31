// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract KYCToken is ERC20 {
    mapping(address => string) private knownCustomers;

    constructor() ERC20("KYC Token", "KYC") {}

    function kyc(string calldata name) public {
        // Make sure 'name' is not empty
        require(!_isEmpty(name));
        knownCustomers[msg.sender] = name;
    }

    function _isValidKYC(address user) internal view returns (bool) {
        // Check if user is peresent in knownCustomers DB
        return !_isEmpty(knownCustomers[user]);
    }

    function _isAccredited(address user) internal view returns (bool) {
        return user.balance >= 1 ether;
    }

    function _isEmpty(string memory value) internal pure returns (bool) {
        return bytes(value).length == 0;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal view override {
        require(
            from == address(0) || (_isValidKYC(from) && _isAccredited(from)),
            "Depositor does not have valid KYC or accreditation!"
        );
        require(
            to == address(0) || (_isValidKYC(to) && _isAccredited(to)),
            "Receiver does not have valid KYC or accreditation!"
        );
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external {
        _burn(from, amount);
    }
}
