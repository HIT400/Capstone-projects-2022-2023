import React, { useState, useEffect } from 'react';
import { ethers } from 'ethers';

const OwnershipHistory = ({ contract, nftID }) => {
  const [history, setHistory] = useState([]);

  useEffect(() => {
    const fetchOwnershipHistory = async () => {
      try {
        const ownershipHistory = await contract.getOwnershipHistory(nftID);
        setHistory(ownershipHistory);
      } catch (error) {
        console.error('Error fetching ownership history:', error);
      }
    };

    if (contract && nftID) {
      fetchOwnershipHistory();
    }
  }, [contract, nftID]);

  return (
    <div>
      <h3>Ownership History</h3>
      <ul>
        {history.map((address, index) => (
          <li key={index}>{address}</li>
        ))}
      </ul>
    </div>
  );
};

export default OwnershipHistory;
