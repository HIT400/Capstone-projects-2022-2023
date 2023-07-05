import { ethers, Contract } from 'ethers';
import { useEffect, useState } from 'react';
import moment from 'moment/moment';
import History from '../history';


import OwnershipHistory from '../OwnershipHistory';

import close from '../assets/close.svg';




const Home = ({ home, provider, account, escrow, togglePop }) => {
    const [hasBought, setHasBought] = useState(false)
    const [hasLended, setHasLended] = useState(false)
    const [hasInspected, setHasInspected] = useState(false)
    const [hasSold, setHasSold] = useState(false)

    const [buyer, setBuyer] = useState(null)
    const [lender, setLender] = useState(null)
    const [inspector, setInspector] = useState(null)
    const [seller, setSeller] = useState(null)

    const [owner, setOwner] = useState(null)
    const [toggle, setToggle] = useState(false);

    const [history, setHistory] = useState(null)


    const fetchDetails = async () => {
        // -- Buyer

        const buyer = await escrow.buyer(home.id)
        setBuyer(buyer)

        const hasBought = await escrow.approval(home.id, buyer)
        setHasBought(hasBought)

        // -- Seller

        const seller = await escrow.seller()
        setSeller(seller)

        const hasSold = await escrow.approval(home.id, seller)
        setHasSold(hasSold)

        // -- Lender

        const lender = await escrow.lender()
        setLender(lender)

        const hasLended = await escrow.approval(home.id, lender)
        setHasLended(hasLended)

        // -- Inspector

        const inspector = await escrow.inspector()
        setInspector(inspector)

        const hasInspected = await escrow.inspectionPassed(home.id)
        setHasInspected(hasInspected)

        

        
    }
    

    const fetchOwner = async () => {
        if (await escrow.isListed(home.id)) return

        const owner = await escrow.buyer(home.id)
        setOwner(owner)
    }

    const buyHandler = async () => {
        const escrowAmount = await escrow.escrowAmount(home.id)
        const signer = await provider.getSigner()

        // Buyer deposit earnest
        let transaction = await escrow.connect(signer).depositEarnest(home.id, { value: escrowAmount })
        await transaction.wait()

        // Buyer approves...
        transaction = await escrow.connect(signer).approveSale(home.id)
        await transaction.wait()

        setHasBought(true)
        document.getElementsByClassName("home__buy")[0].innerHTML = "Request Sent";
    }

    const inspectHandler = async () => {
        const signer = await provider.getSigner()

        // Inspector updates status
        const transaction = await escrow.connect(signer).updateInspectionStatus(home.id, true)
        await transaction.wait()

        setHasInspected(true)
        document.getElementsByClassName("home__buy")[0].innerHTML = "Request Approved";
    }

    const previousOwners = async () => {
        const signer = await provider.getSigner()
        try {
            const history = await escrow.connect(signer).getOwnershipHistory(home.id);
            await history.wait()
            console.log(history);
            <div>history.from</div>
            setHistory(history);
            console.log(history)
        } catch (error) {
            console.log(error);
        }
    };

    const lendHandler = async () => {
        const signer = await provider.getSigner()

        // Lender approves...
        const transaction = await escrow.connect(signer).approveSale(home.id)
        await transaction.wait()

        // Lender sends funds to contract...
        const lendAmount = (await escrow.purchasePrice(home.id) - await escrow.escrowAmount(home.id))
        await signer.sendTransaction({ to: escrow.address, value: lendAmount.toString(), gasLimit: 60000 })

        setHasLended(true)
        document.getElementsByClassName("home__buy")[0].innerHTML = "Deposited";
    }

    const sellHandler = async () => {
        const signer = await provider.getSigner()

        // Seller approves...
        let transaction = await escrow.connect(signer).approveSale(home.id)
        await transaction.wait()

        // Seller finalize...
        transaction = await escrow.connect(signer).finalizeSale(home.id)
        await transaction.wait()

        setHasSold(true)
    }
   
    const showH = async () =>{
        const signer = await provider.getSigner()

        try {
            const history = await escrow.connect(signer).getOwnershipHistory(home.id);
            console.log(history);
            setHistory(history);
            window.location.replace('http://127.0.0.1:5500/src/history.html');
        } catch (error) {
            console.log(error);
        }
    }

    const showHistory = async () => {
        const signer = await provider.getSigner()
        try {
            const history = await escrow.connect(signer).getOwnershipHistory(home.id);
            console.log(history);
            setHistory(history);
            window.location.replace('http://127.0.0.1:5500/src/his.html');
        } catch (error) {
            console.log(error);
        }


    }

    

    useEffect(() => {
        fetchDetails()
        fetchOwner()
        
        
        
    }, [hasSold])

    return (
        <div className="home">
            <div className='home__details'>
                <div className="home__image">
                    <img src={home.image} alt="Home" />
                </div>
                <div className="home__overview">
                    <h1>{home.name}</h1>
                    <p>
                        <strong>{home.attributes[2].value}</strong> bds |
                        <strong>{home.attributes[3].value}</strong> ba |
                        <strong>{home.attributes[4].value}</strong> sqrm |
                    </p>
                    <p>{home.address}</p>

                    <h2>{home.attributes[0].value} ETH</h2>

                    {owner ? (
                        <div >
                           <div className='home__owned'> Owned by {owner.slice(0, 6) + '...' + owner.slice(38, 42)}<br/> </div>
                           
                           <div
                                className="home__owned"
                                style={{
                                    backgroundColor: "#4CAF50",
                                    border: "none",
                                    color: "white",
                                    padding: "10px 20px",
                                    textAlign: "center",
                                    textDecoration: "none",
                                    display: "inline-block",
                                    fontSize: "16px",
                                    margin: "4px 2px",
                                    cursor: "pointer",
                                    marginLeft:"6.5cm"
                                }}
                                onClick = {showH}
                                >
                                Show History
                        </div>
                            
                        </div>
                        
                        ) : (
                        <div>
                            {(account === inspector) ? (
                                <button className='home__buy' onClick={inspectHandler} disabled={hasInspected}>
                                    Approve Request
                                </button>
                            ) : (account === lender) ? (
                                <button className='home__buy' onClick={lendHandler} disabled={hasLended}>
                                    Deposit
                                </button>
                            ) : (account === seller) ? (
                                <button className='home__buy' onClick={sellHandler} disabled={hasSold}>
                                    Approve & Sell
                                </button>
                            ) : (
                                <button className='home__buy' onClick={buyHandler} disabled={hasBought}>
                                    Buy
                                </button>
                            )}

                            <button className='home__contact' onClick={showHistory}>
                                Show History
                            </button>
                        </div>
                        )
                    }

                    <hr />

                    <h2>Overview</h2>

                    <p>
                        {home.description}
                    </p>

                    <hr />

                    <h2>Facts and features</h2>

                    <ul>
                        {home.attributes.map((attribute, index) => (
                            <li key={index}><strong>{attribute.trait_type}</strong> : {attribute.value}</li>
                        ))}
                    </ul>

                    
                </div>


                <button onClick={togglePop} className="home__close">
                    <img src={close} alt="Close" />
                </button>
            </div>
        </div >
    );
}

export default Home;