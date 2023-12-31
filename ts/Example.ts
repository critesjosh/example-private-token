
/* Autogenerated file, do not edit! */

/* eslint-disable */
import { AztecAddress, CompleteAddress, ContractBase, ContractFunctionInteraction, ContractMethod, DeployMethod, FieldLike, Wallet } from '@aztec/aztec.js';
import { Fr, Point } from '@aztec/foundation/fields';
import { AztecRPC, PublicKey } from '@aztec/types';
import { ContractAbi } from '@aztec/foundation/abi';
import ExampleContractAbiJson from '../target/Example.json' assert { type: 'json' };
export const ExampleContractAbi = ExampleContractAbiJson as unknown as ContractAbi;

/**
 * Type-safe interface for contract Example;
 */
export class ExampleContract extends ContractBase {
  
  private constructor(
    /** The deployed contract's complete address. */
    completeAddress: CompleteAddress,
    /** The wallet. */
    wallet: Wallet,
  ) {
    super(completeAddress, ExampleContractAbi, wallet);
  }
  

  
  /**
   * Creates a contract instance.
   * @param address - The deployed contract's address.
   * @param wallet - The wallet to use when interacting with the contract.
   * @returns A promise that resolves to a new Contract instance.
   */
  public static async at(
    /** The deployed contract's address. */
    address: AztecAddress,
    /** The wallet. */
    wallet: Wallet,
  ) {
    const extendedContractData = await wallet.getExtendedContractData(address);
    if (extendedContractData === undefined) {
      throw new Error('Contract ' + address.toString() + ' is not deployed');
    }
    return new ExampleContract(extendedContractData.getCompleteAddress(), wallet);
  }

  
  /**
   * Creates a tx to deploy a new instance of this contract.
   */
  public static deploy(rpc: AztecRPC, initial_supply: (bigint | number), owner: FieldLike, owner_note_secret: FieldLike) {
    return new DeployMethod<ExampleContract>(Point.ZERO, rpc, ExampleContractAbi, Array.from(arguments).slice(1));
  }

  /**
   * Creates a tx to deploy a new instance of this contract using the specified public key to derive the address.
   */
  public static deployWithPublicKey(rpc: AztecRPC, publicKey: PublicKey, initial_supply: (bigint | number), owner: FieldLike, owner_note_secret: FieldLike) {
    return new DeployMethod<ExampleContract>(publicKey, rpc, ExampleContractAbi, Array.from(arguments).slice(2));
  }
  

  
  /**
   * Returns this contract's ABI.
   */
  public static get abi(): ContractAbi {
    return ExampleContractAbi;
  }
  

  /** Type-safe wrappers for the public methods exposed by the contract. */
  public methods!: {
    
    /** compute_note_hash_and_nullifier(contract_address: field, nonce: field, storage_slot: field, preimage: array) */
    compute_note_hash_and_nullifier: ((contract_address: FieldLike, nonce: FieldLike, storage_slot: FieldLike, preimage: FieldLike[]) => ContractFunctionInteraction) & Pick<ContractMethod, 'selector'>;

    /** getBalance(owner: field) */
    getBalance: ((owner: FieldLike) => ContractFunctionInteraction) & Pick<ContractMethod, 'selector'>;

    /** mint(amount: integer, recipient: field) */
    mint: ((amount: (bigint | number), recipient: FieldLike) => ContractFunctionInteraction) & Pick<ContractMethod, 'selector'>;

    /** onTransfer(amount: field) */
    onTransfer: ((amount: FieldLike) => ContractFunctionInteraction) & Pick<ContractMethod, 'selector'>;

    /** totalTransferred() */
    totalTransferred: (() => ContractFunctionInteraction) & Pick<ContractMethod, 'selector'>;

    /** transfer(amount: integer, recipient: field) */
    transfer: ((amount: (bigint | number), recipient: FieldLike) => ContractFunctionInteraction) & Pick<ContractMethod, 'selector'>;

    /** transfer_ownership(secret: field, recipient: field) */
    transfer_ownership: ((secret: FieldLike, recipient: FieldLike) => ContractFunctionInteraction) & Pick<ContractMethod, 'selector'>;
  };
}
