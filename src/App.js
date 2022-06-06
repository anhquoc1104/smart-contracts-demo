import React, { useEffect, useState } from 'react';
import Web3 from 'web3';
import "./App.css";
import detectEthereumProvider from '@metamask/detect-provider'


const App = () => {
  const [web3Api, setWeb3Api] = useState({
    provider: null,
    web3: null
  })
  const [account, setAccount] = useState(null)


  useEffect(() => {
    const loadProvider = async () => {
      const provider = await detectEthereumProvider()

      if (provider) {
        // provider.request({ method: 'eth_requestAccounts' })
        setWeb3Api({
          provider,
          web3: new Web3(provider)
        })
      } else console.error('Have not MetaMask');
    }
  }, [])

  useEffect(() => {
    const getAccount = async () => {
      const accounts = await web3Api.web3.eth.getAccounts()
      setAccount(accounts[0])
    }
    web3Api.web3 && getAccount() && reloadEffect()
  }, [web3Api.web3])

  return (
    <div className='faucet-wrapper'>
      <div className='faucet'>
        <div className='balance-view is-size-2'>
          Curent Balance: <strong>10 ETH</strong>
        </div>
        <div className='balance-button'>
          <button className='button is-pramary mr-5'>Donate</button>
          <button className='button is-danger'>Withdraw</button>
          <button className='button is-link' onClick={() => {
            web3Api.provider.request({ method: "eth_requestAccounts" })
          }}>Connect Wallets</button>
        </div>
        <span>
          <p>
            <strong>Account Address: </strong>
            {
              account ? account : "Accont Denied"
            }
          </p>

        </span>
      </div>
    </div>
  )
}

export default App