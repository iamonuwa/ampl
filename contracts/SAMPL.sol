// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
    @title Wrapped AMPL
 */

contract SAMPL is ERC20 {
    using SafeERC20 for IERC20;

    address private ampl;

    uint256 public constant MAX_SAMPL_SUPPLY = 10 ** 18 * 1000;
    
    constructor(string memory _name, string memory _symbol, address _ampl) ERC20(_name, _symbol) {
        ampl = _ampl;
    }

    function mint(uint256 _amount) external {
        uint256 amplQuantity = convertSAMPLToAMPL(_amount, amplTotalSupply());
        deposit(_msgSender(), _msgSender(), amplQuantity, _amount);
    }
    function burn(uint256 _amount) external {
        uint256 amplQuantity = convertSAMPLToAMPL(_amount, amplTotalSupply());
        withdraw(_msgSender(), _msgSender(), amplQuantity, _amount);
    }
    function withdraw(address from, address to, uint256 amplQuantity, uint256 samplQuantity) private {
        _burn(from, samplQuantity);
        IERC20(ampl).safeTransfer(to, amplQuantity);
    }
    function deposit(address from, address to, uint256 amplQuantity, uint256 samplQuantity) private {
        IERC20(ampl).safeTransferFrom(from, address(this), amplQuantity);
        _mint(to, samplQuantity);
    }

    function amplTotalSupply() private view returns (uint256) {
        return IERC20(ampl).totalSupply();
    }

    function convertAMPLToSAMPL(uint256 amplQuantity, uint256 totalSupply) private pure returns (uint256) {
        return (amplQuantity * MAX_SAMPL_SUPPLY) / totalSupply;
    }

    function convertSAMPLToAMPL(uint256 samplQuantity, uint256 totalSupply) private pure returns (uint256) {
        return (samplQuantity * totalSupply) / MAX_SAMPL_SUPPLY;
    }

    function underlying() external view returns (address) {
        return ampl;
    }

}