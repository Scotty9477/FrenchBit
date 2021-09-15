pragma solidity ^0.8.2;
// SPDX-License-Identifier: Unlicensed

import ".deps/npm/@openzeppelin/contracts/token/ERC20/ERC20.sol";

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}
contract frenchbit is ERC20{
    
    address feeWallet =  0xDA1675aae7db527372563419e6B78ea54c86FfC9;
    address burnWallet = 0xdE3dFD56dc03944ed093b13Fc80d174F16E8075c;
    address charityWallet = 0xDfD0C65CD3DFE652ECa240a5B1eC08f0b1336c2e;
    using SafeMath for uint;
    
   
    constructor() ERC20("FrenchBit", "FBT") {
        _mint(msg.sender, 10000000*10**9);
    }
    
    function applyFee(uint256 amount) private pure returns(uint256){
        return amount.sub(amount.div(100).mul(5));
    }
    
    function applyDecimal(uint256 amount) private pure returns(uint256){
        return amount*10**9;
    }
    
    function transfer(address to, uint256 amount) public virtual returns(bool){
        _transfer(msg.sender, feeWallet, applyDecimal(amount).div(100).mul(5));
        _transfer(msg.sender, to, applyFee(applyDecimal(amount)));
        return true;
    } 
    
    function withdrawFee(uint256 percentCharity, uint256 percentBurn) public virtual returns(bool){
        require(percentCharity.add(percentBurn) == 100, 'withdrawal must be equals to 100%');
        require(balanceOf(feeWallet) > 0, 'feeWallet is empty');
        _transfer(feeWallet, burnWallet, balanceOf(feeWallet).div(100).mul(percentBurn));
        _transfer(feeWallet, charityWallet, balanceOf(feeWallet));
        return true;
    }
    
    function transferFrom(address From, address to, uint256 amount) public virtual returns(bool){
        _transfer(From, feeWallet, applyDecimal(amount).div(100).mul(5));
        _transfer(From, to, applyFee(applyDecimal(amount)));
        return true;
    } 
    function Burn(uint256 amount) public virtual{
        uint256 BurnAmount = amount*10**9;
        _burn(burnWallet, BurnAmount);
    }
    
}