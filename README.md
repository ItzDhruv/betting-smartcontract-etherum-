Betting DApp Smart Contract :

This repository contains the Solidity smart contract for a decentralized betting application. The smart contract allows users to create and join bets, with features like random winner selection, platform fees, and more.

Features
Create Bets: Users can create bets by specifying a unique ID, bet amount, cryptocurrency type, and duration.
Join Bets: Participants can join active bets by contributing the required amount.
Random Winner Selection: A random winner is chosen after the bet duration ends using a random seed.
Platform Fee: A percentage of the total prize pool is deducted as a platform fee.
Prize Distribution: The winner receives the prize after deducting the platform fee.
Contract Overview
Contract Name: BettingDapp
Functions:
createBet

Parameters: betId, betAmount, cryptoType, betDuration
Description: Allows users to create a new bet.
joinBet

Parameters: betId
Description: Allows users to join an existing active bet by sending the required amount of Ether.
endBet

Parameters: betId, randomSeed
Description: Ends the bet, selects a random winner, and distributes the prize pool.
setPlatformFeePercentage

Parameters: newFee
Description: Updates the platform fee percentage (restricted to the contract owner).
getBetDetails

Parameters: betId
Returns: Bet details such as bet amount, creator, participants, winner, and status.
How It Works
Bet Creation:
A user creates a bet by calling createBet and specifying a unique betId. The contract stores the bet details and calculates the end time based on the duration.

Joining a Bet:
Participants can join a bet by calling joinBet and sending the exact Ether amount required.

Ending the Bet:
Once the bet duration ends, the creator can call endBet. A random participant is selected as the winner, and the prize is distributed after deducting the platform fee.

Platform Fee:
The platform fee is transferred to the owner's wallet.

![img alt](https://github.com/ItzDhruv/betting-smartcontract-etherum-/blob/8049c712a6fe42eba2f8d484a64ab84eda461126/Screenshot%202025-01-23%20213335.png)


![img alt](https://github.com/ItzDhruv/betting-smartcontract-etherum-/blob/8049c712a6fe42eba2f8d484a64ab84eda461126/Screenshot%202025-01-23%20213523.png)
