// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "./Ownable.sol";
import "./ReentrancyGuard.sol";
import "./Initializable.sol";
import "./IERC20.sol";

contract TokenStacking is Ownable, ReentrancyGuard , Initializable{
    struct User{
    uint256 stakeAmount;
    uint256 rewardAmount;
    uint256 lastStakeTime;
    uint256 lastRewardCalculationTime;
    uint256 rewardsClaimedSoFar;
}

    uint256 _minimumStakingAmount;

    uint256 _maxStakeTokenLimit;

    uint256 _stakeEndDate;

    uint256 _stakeStartDate;

    uint256 _totalStakedTokens;

    uint256 _totalUsers;

    uint256 _stakeDays;

    uint256 _earlyUnstakeFeePercentage;

    bool _isStakingPaused;

    address private _tokenAddress;

    uint256 _apyRate;

    uint256 public constant PERCENTAGE_DENOMINATOR = 10000;
    uint256 public constant APY_RATE_CHANGE_THRESHOLD = 10;


    // User Address => User

    mapping(address => User) private _users;

    event Stake(address indexed user , uint256 amount);
    event UnStake(address indexed user , uint256 amount);
    event EarlyUnStakeFee(address indexed user , uint256 amount);


    modifier whenTreasuryHasBalance(uint256 amount){
        require(
            IERC20(_tokenAddre)
        )
    }





}

