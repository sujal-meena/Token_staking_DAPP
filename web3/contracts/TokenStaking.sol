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
    event ClaimReward(address indexed user , uint256 amount);

    modifier whenTreasuryHasBalance(uint256 amount){
        require(
            IERC20(_tokenAddress).balanceOf(address(this)) >= amount,
            "Insufficient funds!!"
        );
        _;
    }

    function initialize(
        address owner_,
        address tokenAddress_,
        uint256 apyRate_,
        uint256 minimumStakingAmount_,
        uint256 maxStakeTokenLimit_,
        uint256 stakeStartDate_,
        uint256 stakeEndDate_,
        uint256 stakeDays_,
        uint256 earlyUnstakeFeePercentage_
    )public virtual initializer{
        _TokenStaking_init_unchained(
            owner_,
            tokenAddress_,
            apyRate_,
            minimumStakingAmount_,
            maxStakeTokenLimit_,
            stakeStartDate_,
            stakeEndDate_,
            stakeDays_,
            earlyUnstakeFeePercentage_
        );
    }

    function __TokenStaking_init_unchained(
        address owner_,
        address tokenAddress_,
        uint256 apyRate_,
        uint256 minimumStakingAmount_,
        uint256 maxStakeTokenLimit_,
        uint256 stakeStartDate_,
        uint256 stakeEndDate_,
        uint256 stakeDays_,
        uint256 earlyUnstakeFeePercentage_
    )internal onlyInitializing {
        require(_apyRate <= 10000,"apy rate should be less than 10000");
        require(stakeDays_ > 0,"Staking days must be non zero");
        require(tokenAddress_ != address(0),"Token address cannot be a 0 address");
        require(stakeStartDate_ < stakeEndDate_ ,"Start date must be less than end date");


        _transferOwnership(owner_);
        
        _tokenAddress = tokenAddress_;
        _apyRate = apyRate_;
        _minimumStakingAmount = minimumStakingAmount_;
        _stakeStartDate = stakeStartDate_;
        _maxStakeTokenLimit = maxStakeTokenLimit_;
        _stakeEndDate = stakeEndDate_;
        _stakeDays = stakeDays_ * 1 days;
        _earlyUnstakeFeePercentage = earlyUnstakeFeePercentage_;

    }

    //View Methods Start

    /**
    Function to get minimum staking amount
     */

    function getMinimumStakingAmount() external view returns (uint256){
        return _minimumStakingAmount;
        
    }

    function getMaxStakingTokenLimit() external view returns (uint256){

        return _maxStakeTokenLimit;
    }

    function getStakeStartDate() external view returns (uint256){
        return _stakeStartDate;

}
    function getStakeEndDate() external view returns (uint256){
        return _stakeEndDate;
}


    function getTotalStakedTokens() external view returns (uint256){
        return _totalStakedTokens;
}

    function getTotalUsers() external view returns (uint256){
        return _totalUsers;
}

    function getStakeDays() external view returns (uint256){
        return _stakeDays;
}
    function getEarlyUnstakingFeePercentage() external view returns (uint256){ 
        return _earlyUnstakeFeePercentage;
        
    }

    function getStakingStatus() external view returns (uint256){ 
        return _isStakingPaused;
        
    }

    function getAPY() external view returns (uint256){ 
        return _apyRate;
        
    }

    function getUserEstimatedRewards() external view returns (uint256){ 
        (uint256 amount , ) = _getUserEstimatedRewards(msg.sender);
        return _users(msg.sender).rewardAmount + amount;
        
    }
    function getWithdrawableAmount() external view returns (uint256){ 
        return IERC20(_tokenAddress).balanceOf(address(this)) - _totalStakedTokens;
        
    }


    function getUser(address userAddresss) external view returns (User memory){
        return _users(userAddresss);
    }


    function isStakeHolder(address _user) external view returns (bool){
        returns _users[_user].stakeAmount != 0;
    }


    


}

