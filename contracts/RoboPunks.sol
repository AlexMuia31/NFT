// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzepplin/contracts/token/ERC721/ERC721.sol"; // importing a contract that we use for minting
import "@openzepplin/contracts/access/Ownable.sol"; //allow function definition for the owner

contract RoboPunksNFT is ERC721, Ownable {
    uint256 public mintPrice;
    uint256 public totalSupply;
    uint256 public maxSupply;
    uint256 public maxPerWallet; // max number of NFts a wallet can mint
    bool public isPublicMintEnabled; //determines when the users can mint
    string internal baseTokenUri; // url for the images
    address payable public withdrawWallet;
    mapping(address => uint256) public walletMints; //keep track of the mints done per wallet

    constructor() payable ERC721("RoboPunks", "RP") {
        mintPrice = 0.02 ether;
        totalSupply = 0;
        maxSupply = 1000;
        maxPerWallet = 3;
    }

    function setIsPublicMintEnabled(bool isPublicMintEnabled_)
        external
        onlyOwner
    {
        isPublicMintEnabled = isPublicMintEnabled_;
    }

    function setBaseTokenUri(string calldata baseTokenUri_) external onlyOwner {
        baseTokenUri = baseTokenUri_;
    }

    function tokenURI(uint256 tokenId_)
        public
        view
        override
        returns (string memory)
    {
        require(_exists(tokenId_), "Token does not exist!");
        return
            string(
                abi.encodePacked(
                    baseTokenUri,
                    Strings.toString(tokenId_),
                    ".json"
                )
            );
    }

    function withdraw() external onlyOwner {
        (bool success, ) = withdrawWallet.call{value: address(this).balance}(
            ""
        );
        require(success, "withdraw failed");
    }

    function mint(uint256 quantity_) public payable {
        require(isPublicMintEnabled, "minting not enabled"); // minting set to true
        require(msg.value == quantity_ * mintPrice, "wrong mint value"); //user inputting the correct value
        require(totalSupply + quantity_ <= maxSupply, "sold out"); //make sure that maxSupply is not exceeded
        require(
            walletMints[msg.sender] + quantity_ <= maxPerWallet,
            "exceed max wallet"
        ); // determins the number of mints a wallet can do

        for (uint256 i = 0; i < quantity_; i++) {
            uint256 newTokenId = totalSupply + 1;
            totalSupply++;
            _safeMint(msg.sender, newTokenId);
        }
    }
}
