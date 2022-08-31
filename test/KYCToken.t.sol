// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/KYCToken.sol";

contract KYCTokenTest is Test {
    KYCToken public token;
    address testRunner;

    function setUp() public {
        token = new KYCToken();
        testRunner = address(this);
    }

    /*///////////////////////////////////////////////////////////////
                                KYC LOGIC TESTS
    //////////////////////////////////////////////////////////////*/

    function testFailKYCOnEmptyName() public {
        token.kyc("");
    }

    function testKYC(address random, string memory name) public {
        vm.assume(bytes(name).length > 0);
        vm.prank(random);
        token.kyc(name);
    }

    /*///////////////////////////////////////////////////////////////
                                MINT TESTS
    //////////////////////////////////////////////////////////////*/

    function testFailMintOnNonKYC(address customer) public {
        vm.deal(customer, 1 ether);
        vm.prank(customer);
        token.mint(customer, 100);
    }

    function testMintOnValidKYC(address customer, string memory customerName)
        public
    {
        vm.assume(bytes(customerName).length > 0 && customer != address(0));
        vm.deal(customer, 1 ether);
        vm.startPrank(customer); // Run test from given 'customer' address
        token.kyc(customerName);
        token.mint(customer, 100);
        vm.stopPrank();
    }

    function testFailMintIfNotAccredited(address customer, uint256 amount)
        public
    {
        vm.assume(amount < 0.1 ether);
        vm.deal(customer, amount);

        vm.startPrank(customer);
        token.kyc("Random name");
        token.mint(customer, 100);
        vm.stopPrank();
    }

    function testMintIfAccredited(address customer, uint256 amount) public {
        vm.assume(amount >= 0.1 ether);
        vm.assume(customer != address(0));
        vm.deal(customer, amount);

        vm.startPrank(customer);
        token.kyc("Random name");
        token.mint(customer, 100);
        vm.stopPrank();
    }

    /*///////////////////////////////////////////////////////////////
                                TRANSFER TESTS
    //////////////////////////////////////////////////////////////*/

    function testTransferToNonKYC(address kycCustomer, address customer)
        public
    {
        vm.assume(customer != kycCustomer && customer != address(0));
        vm.assume(kycCustomer != address(0));
        // Authorize and mint some KYC to kycCustomer
        vm.deal(kycCustomer, 1 ether);
        vm.startPrank(kycCustomer);
        token.kyc("Test runner");
        token.mint(kycCustomer, 1e18);
        vm.expectRevert("Receiver does not have valid KYC or accreditation!");
        token.transfer(customer, 1e3);
        vm.stopPrank();
    }
}
