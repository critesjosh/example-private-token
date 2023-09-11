import { AztecRPC, AccountWallet, createAztecRpcClient, getSchnorrAccount, waitForSandbox, Wallet } from '@aztec/aztec.js';
import { GrumpkinScalar } from '@aztec/circuits.js';
import { ExampleContract } from '../Example.js';

const { SANDBOX_URL = 'http://localhost:8080' } = process.env;

let rpc: AztecRPC;
let account: AccountWallet;
let exampleContract: ExampleContract;

describe('Testing Example Aztec contract', () => {

    beforeEach(async () => {
        rpc = createAztecRpcClient(SANDBOX_URL);
        // await waitForSandbox(rpc);
        // [account] = await getSandboxAccountsWallets(rpc);

    });

    afterEach(() => {

    })

    it('does a test', async () => {
        account = await getSchnorrAccount(rpc, GrumpkinScalar.random(), GrumpkinScalar.random()).waitDeploy();
        expect(account).toBeDefined();
    })

    it('Deploys a contract', async () => {
        const address = await account.getAddress();
        const exampleContract = await ExampleContract.deploy(rpc, 100n, address, 123).send().deployed();
        expect(exampleContract).toBeDefined();
    })

    it('Transfers a token', () => {

    })

})



