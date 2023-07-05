import React, { useEffect, useState } from "react";


function History() {
  useEffect(() => {
    const dt = new Date();
    const date = dt.toLocaleDateString();
    const time = dt.toTimeString().slice(0, 8);
    const datetime = date + " " + time;
    document.getElementById("demo").innerHTML = datetime;
  }, []);

   const [history, setHistory] = useState([]);
const OwnershipHistory = ({ contract, nftID }) => {
  
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

  return (
    <div>
      <table style={{ width: "100%" }}>
        <thead>
          <tr>
            <th>Owner Address</th>
            <th>Date Of ownership</th>
            <th>Seller</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>0xe7f1725e7734ce288f8367e1bb143e90bb3f0512</td>
            <td>4/26/2023 07:21:15</td>
            <td></td>
          </tr>
          <tr>
            <td>
              <br />
              0x70997970C51812dc3A010C7d01b50e0d17dc79C8
            </td>
            <td>
              <br />
              4/26/2023 07:22:15
            </td>
            <td>
              <br />
              0xe7f1725e7734ce288f8367e1bb143e90bb3f0512
            </td>
          </tr>
          <tr>
            <td>0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266</td>
            <td>
              <p id="demo"></p>
            </td>
            <td>0x70997970C51812dc3A010C7d01b50e0d17dc79C8</td>
          </tr>
        </tbody>
      </table>
    </div>
  );
}

export default History;