// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzepplin/contracts/token/ERC721/ERC721.sol"; // importing a contract that we use for minting
import "@openzepplin/contracts/access/Ownable.sol"; //allow function definition for the owner

contract RoboPunksNFT is ERC721, Ownable {
    uint256 public mintPrice;
    uint256 public totalSupply;
    uint256 public maxSupply;
    uint256 public maxPerWallet;
    bool public isPublicMintEnabled;
    string internal baseTokenUri;
    address payable public withdrawWallet;
    mapping(address => uint256) public walletMints;
}
