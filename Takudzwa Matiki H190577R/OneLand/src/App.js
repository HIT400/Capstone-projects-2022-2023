import { useEffect, useState } from 'react';
import { ethers } from 'ethers';
import { SearchBar } from 'react-native-screens';
import { styles } from './styles';

import React from 'react';
import { View, TextInput, FlatList, Text } from 'react-native';

// Components
import Navigation from './components/Navigation';
import Search from './components/Search';
import Home from './components/Home';


// ABIs
import RealEstate from './abis/RealEstate.json'
import Escrow from './abis/Escrow.json'

// Config
import config from './config.json';

function App() {
    const [provider, setProvider] = useState(null)
    const [escrow, setEscrow] = useState(null)

    const [account, setAccount] = useState(null)

    const [homes, setHomes] = useState([])
    const [home, setHome] = useState({})
    const [toggle, setToggle] = useState(false);

    const [query, setQuery] = useState('');
    const [data, setData] = useState(homes);


    const loadBlockchainData = async() => {
        const provider = new ethers.providers.Web3Provider(window.ethereum)
        setProvider(provider)
        const network = await provider.getNetwork()


        const realEstate = new ethers.Contract(config[network.chainId].realEstate.address, RealEstate, provider)
        const totalSupply = await realEstate.totalSupply()
        const homes = []
        console.log(homes);

        for (var i = 1; i <= totalSupply; i++) {
            const uri = await realEstate.tokenURI(i)
            const response = await fetch(uri)
            const metadata = await response.json()
            homes.push(metadata)
        }

        setHomes(homes)
        setData(homes)


        const escrow = new ethers.Contract(config[network.chainId].escrow.address, Escrow, provider)
        setEscrow(escrow)

        window.ethereum.on('accountsChanged', async() => {
            const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
            const account = ethers.utils.getAddress(accounts[0])
            setAccount(account);
        })
    }

    useEffect(() => {
        loadBlockchainData()
    }, [])

    const togglePop = (home) => {
        setHome(home)
        toggle ? setToggle(false) : setToggle(true);
    }

    const handleSearch = (text) => {

        setQuery(text);
        // Filter the data array based on the search query


        for (var i = 0; i <= homes.length - 1; i++) {
            console.log(homes[i].attributes[0].value);


            // code for filter
            // Filter the homes array based on the search query
            const filteredData = data.filter((homes) => homes.price.match(text));
            console.log(filteredData);
            // Set the data state to the filtered homes
            setData(filteredData);

        }
        console.log('====================================');
        console.log(data);
        console.log('====================================');

    }
    const [text, setText] = useState('');
    const handleReset = () => {
        setQuery('');
    }



    return (

        <
        div >
        <
        Navigation account = { account }
        setAccount = { setAccount }
        /> <
        Search / >


        <
        div >
        <
        TextInput placeholder = "Price range..."
        className = "searchbar"
        id = 'myButton'
        style = { styles.searchbar }
        onChangeText = { handleSearch }
        value = { query }
        clearButtonMode = "always" /
        >
        <
        /div>


        <
        div className = 'cards__section' >

        <
        h3 > Homes For You < /h3>

        <
        hr / >

        {
            handleSearch ? ( < div className = 'cards' > {
                    data.map((home, index) => ( <
                        div className = 'card'
                        key = { index }
                        onClick = {
                            () => togglePop(home) } >
                        <
                        div className = 'card__image' >
                        <
                        img src = { home.image }
                        alt = "Home" / >
                        <
                        /div> <
                        div className = 'card__info' >
                        <
                        h4 > { home.attributes[0].value }
                        ETH < /h4> <
                        p > { home.description } {
                            /* <strong>{home.attributes[3].value}</strong> ba |
                                              <strong>{home.attributes[4].value}</strong> sqft */
                        } <
                        /p> <
                        p > { home.address } < /p> <
                        /div> <
                        /div>
                    ))
                } <
                /div>

            ) : ( < div className = 'cards' > {
                    data.map((home, index) => ( <
                        div className = 'card'
                        key = { index }
                        onClick = {
                            () => togglePop(home) } >
                        <
                        div className = 'card__image' >
                        <
                        img src = { home.image }
                        alt = "Home" / >
                        <
                        /div> <
                        div className = 'card__info' >
                        <
                        h4 > { home.attributes[0].value }
                        ETH < /h4>

                        <
                        p > { home.description } {
                            /* <strong>{home.attributes[3].value}</strong> ba |
                                              <strong>{home.attributes[4].value}</strong> sqft */
                        } <
                        /p> <
                        p > { home.address } < /p> <
                        /div> <
                        /div>
                    ))
                } <
                /div>)
            }



                <
                /div>

            {
                toggle && ( <
                    Home home = { home }
                    provider = { provider }
                    account = { account }
                    escrow = { escrow }
                    togglePop = { togglePop }
                    />
                )
            }

            <
            /div>
        );
    }

    export default App;