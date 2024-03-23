/** @jsxImportSource frog/jsx */
import { Button, Frog, TextInput, parseEther } from 'frog'
import { neynar } from 'frog/hubs'
import { handle } from 'frog/next'

const app = new Frog({
  assetsPath: '/',
  basePath: '/api',
  hub: neynar({ apiKey: 'NEYNAR_FROG_FM' })
})

app.frame('/', (c) => {
  return c.res({
    action: '/finish',
    image: (
      <div style={{ color: 'white', display: 'flex', fontSize: 60 }}>
        Perform a transaction
      </div>
    ),
    intents: [
      <TextInput placeholder="Value (ETH)" />,
      <Button.Transaction target="/send">Send Ether</Button.Transaction>,
    ]
  })
})
 
app.frame('/finish', (c) => {
  const { transactionId } = c
  return c.res({
    image: (
      <div style={{ color: 'white', display: 'flex', fontSize: 60 }}>
        Transaction ID: {transactionId}
      </div>
    )
  })
})
 
app.transaction('/send', (c) => {
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
