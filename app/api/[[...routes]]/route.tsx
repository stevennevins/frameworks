/** @jsxImportSource frog/jsx */
import { Button, Frog, TextInput, parseEther } from 'frog'
import { neynar } from 'frog/hubs'
import { handle } from 'frog/next'

const app = new Frog({
  assetsPath: '/',
  basePath: '/api',
  hub: neynar({ apiKey: 'NEYNAR_FROG_FM' })
})


const renderTableRows = (data) => {
  return data.map((item) => (
    <tr key={item.rank}>
      <td>{item.rank}</td>
      <td>{item.bidder}</td>
      <td>{item.bid}</td>
    </tr>
  ));
};

const renderBidderTable = (data) => {
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

const data = [
        { rank: 1, bidder: "Alice", bid: 100 },
        { rank: 2, bidder: "Bob", bid: 90 },
        { rank: 3, bidder: "Charlie", bid: 80 },
        { rank: 4, bidder: "Dana", bid: 70 },
        { rank: 5, bidder: "Eve", bid: 60 },
    ];

    return c.res({
        image: (
        <div style={{ display: 'flex' }}>
        {renderBidderTable(data)}
        </div>
        )
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

export const GET = handle(app)
export const POST = handle(app)
