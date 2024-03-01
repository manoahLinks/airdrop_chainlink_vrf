// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./interfaces/IERC20.sol";

contract vrfAirdrop {

    error ADDRESS_ZERO();
    error MAX_ATTEMPT_REACHED();

    address manoToken;

    struct Player {
        uint256 id;
        address userAddress;
        uint256 attempts;
        uint256 points;
        bool isRegistered;
    }

    // constructor
    constructor (uint256 _maxAttempts, uint256 _valuePerPoint, address _manoToken) {
        maxAttempts = _maxAttempts;
        valuePerPoint = _valuePerPoint;
        manoToken = _manoToken;
    }

    // state variables
    uint256 maxAttempts;
    uint256 playerCount;
    uint256 valuePerPoint;

    mapping(address => Player) public players;
    Player[] playerArray;

    modifier onlyRegisteredPlayer () {
        require(players[msg.sender].isRegistered, "Not registered");
        _;
    }

    // registerUser func
    function registerUser() external {

        uint256 _id = playerCount + 1;

        if(msg.sender == address(0)) {
            revert ADDRESS_ZERO(); 
        }

        require(!players[msg.sender].isRegistered, "Already registered");

        Player storage _player = players[msg.sender];

        _player.userAddress = msg.sender;
        _player.id = _id;
        _player.isRegistered = true;

        playerArray.push(Player(_id, msg.sender, 0, 0, true));

        playerCount++;
    }

    // gainPoints func
    function dailyActivity() external onlyRegisteredPlayer {
        
        if(msg.sender == address(0)) {
            revert ADDRESS_ZERO(); 
        }

        if(players[msg.sender].attempts >= maxAttempts) {
            revert MAX_ATTEMPT_REACHED(); 
        }

        // points calculation
        

        Player storage _player = players[msg.sender];

        _player.attempts = _player.attempts + 1;
        _player.points = _player.points + 5;

        Player storage currPlayer = playerArray[_player.id - 1];
        
        currPlayer.attempts = _player.attempts;
        currPlayer.points = _player.points;
    }

    // distribute airdop
    function distributeAirdrop () external  {
        // distribution airdrop based on users reward
        for(uint256 i = 0; i < playerCount; i++) {
            // using erc20 interface to transfer from contract to user based on userPoints and value perpoint
            IERC20(manoToken).transfer(playerArray[i].userAddress, playerArray[i].points * valuePerPoint);
        }
    }

    // get All registered players
    function getAllPlayers () external view returns (Player[] memory) {
        return playerArray;
    }

    // calculate reward
    function calculateReward () external view returns (uint256) {
        return  players[msg.sender].points * valuePerPoint;
    }

}