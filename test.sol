// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
   XYZ Daily Check-In Smart Contract
   ---------------------------------
   - Users can check in once per day (based on block timestamp)
   - The contract stores when each wallet last checked in
   - Anyone can view their last check-in time
   - Owner can view total check-ins
*/

contract DailyCheckIn {
    address public owner;

    // Mapping to store each user's last check-in timestamp
    mapping(address => uint256) public lastCheckIn;

    // Count total number of check-ins
    uint256 public totalCheckIns;

    // Event that logs every successful check-in
    event CheckedIn(address indexed user, uint256 time);

    constructor() {
        owner = msg.sender; // deployer is the owner
    }

    // Function for users to check in
    function checkIn() public {
        // Get the last check-in time
        uint256 lastTime = lastCheckIn[msg.sender];

        // Ensure the user can only check in once per day (86400 seconds)
        require(
            block.timestamp - lastTime >= 1 days,
            "You can only check in once per day"
        );

        // Update their last check-in time
        lastCheckIn[msg.sender] = block.timestamp;

        // Increase total check-in counter
        totalCheckIns++;

        // Emit event
        emit CheckedIn(msg.sender, block.timestamp);
    }

    // View function: check if user already checked in today
    function hasCheckedInToday(address _user) public view returns (bool) {
        if (block.timestamp - lastCheckIn[_user] < 1 days) {
            return true;
        }
        return false;
    }

    // View function: get time since last check-in
    function timeSinceLastCheckIn(address _user) public view returns (uint256) {
        if (lastCheckIn[_user] == 0) return 0;
        return block.timestamp - lastCheckIn[_user];
    }
}
