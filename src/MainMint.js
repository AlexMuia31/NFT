import React, { useState } from "react";
import { ethers, BigNumber } from "ethers";
import roboPunksNFT from "./RoboPunksNFT.json";

const roboPunksNFTAddress = "0x2819751B598f00Ea50325aC574A0e937EBE75f9F";

const MainMint = ({ accounts, setAccounts }) => {
  const [mintAmount, setMintAmount] = useState(1);
  const isConnected = Boolean(accounts[0]);

  async function handleMint() {
    if (window.ethereum) {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner(0);
      const contract = new ethers.Contract(
        roboPunksNFTAddress,
        roboPunksNFT.abi,
        signer
      );
      try {
        const response = await contract.mint(BigNumber.from(mintAmount));
        console.log("response: ", response);
      } catch (err) {
        console.log("error: ", err);
      }
    }
  }
  const handleDecrement = () => {
    if (mintAmount <= 1) return;
    setMintAmount(mintAmount - 1);
  };
  const handleIncrement = () => {
    if (mintAmount >= 3) return;
    setMintAmount(mintAmount + 1);
  };

  return (
    <div>
      <h1>RoboPunks</h1>
      <p>
        Its 2022 and You should mint some NFTs or Will send RoboPunk to come and
        get you. This is not a threat!
      </p>
      {isConnected ? (
        <div>
          <div>
            <button onClick={handleDecrement}>-</button>
            <input type="number" value={mintAmount} />
            <button onClick={handleIncrement}>+</button>
          </div>
          <button onClick={handleMint}>Mint Now</button>
        </div>
      ) : (
        <p>You must be connected to Mint.</p>
      )}
    </div>
  );
};

export default MainMint;
