// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BettingDapp {
    struct Bet {
        string betId;
        uint256 betAmount;
        string cryptoType;
        uint256 betDuration;
        address creator;
        uint256 endTime;
        address[] participants;
        address winner;
        bool isActive;
    }

    mapping(string => Bet) public bets;
    address public platformOwner;
    uint256 public platformFeePercentage = 10; // 10% platform fee

    event BetCreated(string betId, address creator, uint256 betAmount, uint256 endTime);
    event BetJoined(string betId, address participant);
    event BetEnded(string betId, address winner, uint256 winnings);
    event PlatformFeePaid(address owner, uint256 fee);

    modifier onlyCreator(string memory betId) {
        require(msg.sender == bets[betId].creator, "Only the creator can perform this action");
        _;
    }

    modifier betIsActive(string memory betId) {
        require(bets[betId].isActive, "Bet is not active");
        _;
    }

    modifier betIsOver(string memory betId) {
        require(block.timestamp >= bets[betId].endTime, "Bet duration has not ended yet");
        _;
    }

    constructor() {
        platformOwner = msg.sender;
    }

    function createBet(
        string memory betId,
        uint256 betAmount,
        string memory cryptoType,
        uint256 betDuration
    ) external {
        require(bets[betId].creator == address(0), "Bet ID already exists");

        Bet storage newBet = bets[betId];
        newBet.betId = betId;
        newBet.betAmount = betAmount;
        newBet.cryptoType = cryptoType;
        newBet.betDuration = betDuration;
        newBet.creator = msg.sender;
        newBet.endTime = block.timestamp + betDuration;
        newBet.isActive = true;

        emit BetCreated(betId, msg.sender, betAmount, newBet.endTime);
    }

    function joinBet(string memory betId) external payable betIsActive(betId) {
        Bet storage bet = bets[betId];

        require(msg.value == bet.betAmount, "Incorrect Ether amount sent");
        require(block.timestamp < bet.endTime, "Bet duration has ended");
        for (uint256 i = 0; i < bet.participants.length; i++) {
            require(bet.participants[i] != msg.sender, "Participant already joined");
        }

        bet.participants.push(msg.sender);

        emit BetJoined(betId, msg.sender);
    }

    function endBet(string memory betId, uint256 randomSeed)
        external
        onlyCreator(betId)
        betIsActive(betId)
        betIsOver(betId)
    {
        Bet storage bet = bets[betId];
        require(bet.participants.length > 0, "No participants in the bet");

        bet.isActive = false;

        // Select winner using the random seed
        uint256 winnerIndex = randomSeed % bet.participants.length;
        address winner = bet.participants[winnerIndex];
        bet.winner = winner;

        // Calculate total prize pool and platform fee
        uint256 totalPrizePool = bet.participants.length * bet.betAmount;
        uint256 platformFee = (totalPrizePool * platformFeePercentage) / 100;
        uint256 winnerPrize = totalPrizePool - platformFee;

        // Transfer platform fee to the owner
        payable(platformOwner).transfer(platformFee);
        emit PlatformFeePaid(platformOwner, platformFee);

        // Transfer prize money to the winner
        payable(winner).transfer(winnerPrize);
        emit BetEnded(betId, winner, winnerPrize);
    }

    function setPlatformFeePercentage(uint256 newFee) external {
        require(msg.sender == platformOwner, "Only the platform owner can set the fee");
        require(newFee <= 100, "Platform fee percentage cannot exceed 100");
        platformFeePercentage = newFee;
    }

    function getBetDetails(string memory betId)
        external
        view
        returns (
            string memory,
            uint256,
            string memory,
            uint256,
            address,
            uint256,
            address[] memory,
            address,
            bool
        )
    {
        Bet storage bet = bets[betId];
        return (
            bet.betId,
            bet.betAmount,
            bet.cryptoType,
            bet.betDuration,
            bet.creator,
            bet.endTime,
            bet.participants,
            bet.winner,
            bet.isActive
        );
    }
}