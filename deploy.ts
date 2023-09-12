import { AztecRPC, AccountWallet, createAztecRpcClient, getSchnorrAccount, waitForSandbox, Wallet } from '@aztec/aztec.js';

import { ExampleContract } from './ts/Example.js';
const { SANDBOX_URL = 'http://localhost:8080' } = process.env;

// Consider updating to follow the pattern used in the tests
// https://github.com/AztecProtocol/aztec-packages/blob/master/yarn-project/end-to-end/src/e2e_deploy_contract.test.ts

async function main() {
    const rpc = await createAztecRpcClient(SANDBOX_URL);
    const accounts = await rpc.getAccounts();
    const deployer = accounts[0];
    const tx = await ExampleContract.deploy(rpc, 100n, deployer.address, 123).send();
    await tx.wait({ interval: 0.5 });
    const receipt = await tx.getReceipt();
    // const exampleContract = await ExampleContract.at(receipt.contractAddress!, accounts[0].);
    console.log(`Contract deployed.`)
    console.log(receipt);
}

main().catch((e) => {
    console.log("Deployment failed: ", e)
})