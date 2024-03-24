/** @jsxImportSource frog/jsx */
import { Button, Frog, TextInput, parseEther } from 'frog'
import { neynar } from 'frog/hubs'
import { handle } from 'frog/next'
import { createPublicClient, createWalletClient, http } from 'viem';
import { privateKeyToAccount } from 'viem/accounts'
import { optimismSepolia } from 'viem/chains';

import nftData from '../../abi/NFT.json'
import rankedAuctionData from '../../abi/RankedAuction.json'

const NFT_CONTRACT = '0xcb2e1d15c237C0A356dA9C31fd149170190526C5'
const RANKED_AUCTION_CONTRACT = '0x7Ca3870ea6eB34Bf7a0288d533252C87D0B76AF7'

const app = new Frog({
  assetsPath: '/',
  basePath: '/api',
  hub: neynar({ apiKey: 'NEYNAR_FROG_FM' })
})

const renderTableRows = (data: any) => {
  return data.map((item: any) => (
    <tr key={item.rank}>
      <td>{item.rank}</td>
      <td>{item.bidder}</td>
      <td>{item.bid}</td>
    </tr>
  ));
};

const renderBidderTable = (data: any) => {
  return (
    <table style={{ color: 'white', fontSize: 30}}>
      <thead>
        <tr>
          <th>Rank</th>
          <th>Bidder</th>
          <th>Bid</th>
        </tr>
      </thead>
      <tbody>{renderTableRows(data)}</tbody>
    </table>
  );
};
// Function to render the table rows from the data

app.frame('/', (c) => {
    const listBidsData = getReadData();
    console.log("Bid Data:", listBidsData);

    const data = [
        { rank: 1, bidder: "Alice", bid: 100 },
        { rank: 2, bidder: "Bob", bid: 90 },
        { rank: 3, bidder: "Charlie", bid: 80 },
        { rank: 4, bidder: "Dana", bid: 70 },
        { rank: 5, bidder: "Eve", bid: 60 },
    ];

    return c.res({
        action: '',
        image: (
        <div style={{ display: 'flex' }}>
        {renderBidderTable(data)}
        </div>
        ),
        intents: [
            <Button action="/refresh">Refresh</Button>,
            <TextInput placeholder="Bit amount"/>,
            <Button.Transaction target="/bid">Bid</Button.Transaction>,
            <Button action="/view">View NFTs</Button>,
        ]
    })
})


app.frame('/send-eth', (c) => {
  return c.res({
    action: '/send-eth-finish',
    image: (
      <div style={{ color: 'white', display: 'flex', fontSize: 60 }}>
        Perform a transaction
      </div>
    ),
    intents: [
      <TextInput placeholder="Value (ETH)" />,
      <Button.Transaction target="/tx-send-eth">Send Ether</Button.Transaction>,
    ]
  })
})
 
app.frame('/send-eth-finish', (c) => {
  console.log("finish context:", c)
  const { transactionId } = c
  return c.res({
    image: (
      <div style={{ color: 'white', display: 'flex', fontSize: 60 }}>
        Transaction ID: {transactionId || "undefined"}
      </div>
    )
  })
})
 
app.transaction('/tx-send-eth', (c) => {
  const { inputText } = c
  // Send transaction response.
  return c.send({
    chainId: 'eip155:10',
    to: '0x232E02988970e8aB920c83964cC7922d9C282DCA',
    value: parseEther(inputText!!),
  })
})

app.transaction('/bid', (c) => {
  const { frameData, inputText } = c
  // const { castId, fid, messageHash, network, timestamp, url } = frameData
  return c.contract({
    abi: rankedAuctionData["abi"],
    chainId: 'eip155:10',
    functionName: 'bid',
    args: [1],
    to: RANKED_AUCTION_CONTRACT,
    value: parseEther(inputText!!)
  })
})

async function getListBidsData() {
  const publicClient = createPublicClient({ 
    chain: optimismSepolia,
    transport: http()
  })

  try {
    const data = await publicClient.readContract({
      address: RANKED_AUCTION_CONTRACT,
      abi: rankedAuctionData.abi,
      functionName: 'getListBids',
    })
    return data
  } catch (error) {
    console.error("Error fetching bid data:", error)
  }
}

async function getReadData() {
  try {
    const data = await getListBidsData()
    console.log(data)
  } catch (error) {
    console.log("Error reading data:", error)
  }
}

export const GET = handle(app)
export const POST = handle(app)
