import { ethers } from 'ethers';
import logo from '../assets/logo.svg';
import Identicon from "identicon.js";

const Navigation = ({ account, setAccount }) => {
    const connectHandler = async () => {
        const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
        const account = ethers.utils.getAddress(accounts[0])
        setAccount(account);
    }

    return (
        <nav>
            

            <div className='nav__brand' >
                <img src={logo} alt="Logo" />
                <a href=""><h1>OneLand</h1></a>
            </div>

            {account ? (
                <div>
                    <button 
                        type="button" 
                        className='nav__connect'>{account.slice(0, 6) + '...' + account.slice(38, 42)}
                    </button>
                    <img
                        className="identicon"
                        width='30'
                        height='30'
                        src = {`data:image/png;base64, ${new Identicon(account, 30).toString()}`}
                        alt=''
                />
            </div>
            ) : (
                <button
                    type="button"
                    className='nav__connect'
                    onClick={connectHandler}
                >
                    Connect
                </button>
            )}
        </nav>
    );
}

export default Navigation;