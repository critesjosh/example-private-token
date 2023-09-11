# Example Project Walkthrough

- importing Aztec.nr in Nargo.toml

## Compiling contracts

### Requirements

#### nargo

[Installation guide](https://noir-lang.org/getting_started/nargo_installation#installation)

#### aztec-cli

```bash
yarn global add @aztec/cli
```

### Basic

```bash
aztec-cli compile ./path/to/my_aztec_contract_project
```

### With Typescript interfaces

```bash
aztec-cli compile --typescript ./ts .
```

### With Noir interfaces

```bash
aztec-cli compile --interface ./path/to/another_aztec_contract_project/src ./path/to/my_aztec_contract_project
```

## Deploying

The example contract takes 2 args, an amount and an address.

```bash
aztec-cli deploy target/Example.json --args 1000000 $ADDRESS
```

## Testing

Start an Ethereum dev net with

```bash
anvil
```

Start the Sandbox with

```bash
npx @aztec/aztec-sandbox
```

Run tests with

```bash
yarn test
```
