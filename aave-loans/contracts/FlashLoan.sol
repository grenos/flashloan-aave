// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

// Uncomment this line to use console.log
import "hardhat/console.sol";

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import {Ownable} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/Ownable.sol";
import {SafeMath} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/SafeMath.sol";

interface AAVE_LINK_INT {
    function mint(uint256 _wad) external payable;
}

contract FlashLoan is FlashLoanSimpleReceiverBase, Ownable {

    using SafeMath for uint256;
    AAVE_LINK_INT public AAVE_LINK;

    constructor(address _addressProvider, address tokenAddres) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        AAVE_LINK = AAVE_LINK_INT(address(tokenAddres));
    }

    function getTokens() public {
        AAVE_LINK.mint(5000000000000000000);
    }

    /**
     * @notice Executes an operation after receiving the flash-borrowed asset
     * @dev Ensure that the contract can return the debt + premium, e.g., has enough funds to repay and has approved the Pool to pull the total amount
     * @param asset The address of the flash-borrowed asset
     * @param amount The amount of the flash-borrowed asset
     * @param premium The fee of the flash-borrowed asset
     * @param initiator The address of the flashloan initiator
     * @param params The byte-encoded params passed when initiating the flashloan
     * @return True if the execution of the operation succeeds, false otherwise
     */
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        require(msg.sender == address(POOL), "This function can only be called by the Aave Pool");
        require(amount <= IERC20(asset).balanceOf(address(this)), "Invalid balance for the contract");
        require(IERC20(asset).balanceOf(address(this)) > 0, "Zero balance in contract");

        // Your logic goes here.


        // Make sure to have this call at the end
        uint256 amountOwed = amount.add(premium);
        require(IERC20(asset).balanceOf(address(this)) >= amountOwed, "Not enough amount to return loan");
        require(IERC20(asset).approve(address(POOL), amountOwed), "approve failed");
        // IERC20(asset).approve(address(POOL), amountOwed);
        return true;
    }

    function requestFlashLoan(address _asset, uint256 _amount) public onlyOwner {
        require(address(POOL) != address(0), "POOL does not exist!");

        address receiverAddress = address(this);
        address asset = _asset;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        /**
         * @notice Allows smartcontracts to access the liquidity of the pool within one transaction,
         * as long as the amount taken plus a fee is returned.
         * @dev IMPORTANT There are security concerns for developers of flashloan receiver contracts that must be kept
         * into consideration. For further details please visit https://developers.aave.com
         * @param receiverAddress The address of the contract receiving the funds, implementing IFlashLoanSimpleReceiver interface
         * @param asset The address of the asset being flash-borrowed
         * @param amount The amount of the asset being flash-borrowed
         * @param params Variadic packed params to pass to the receiver as extra information
         * @param referralCode The code used to register the integrator originating the operation, for potential rewards.
         *   0 if the action is executed directly by the user, without any middle-man
         **/
        POOL.flashLoanSimple(receiverAddress, asset, amount, params, referralCode);
    }


    function getBalance(address _tokenAddress) external view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function withdraw(address _tokenAddress) external onlyOwner {
        IERC20(_tokenAddress).transfer(msg.sender, IERC20(_tokenAddress).balanceOf(address(this)));
    }

    receive() external payable {}
}