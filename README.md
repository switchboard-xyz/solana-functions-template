# solana-functions-template

## Setup

Edit the Makefile with your docker image name. Make sure to include your docker
organization if publishing to the repository (For example:
`switchboard/my-function`).

## Build

Run the following command to build the docker image with your custom function

```bash
make
```

You should see a `measurement.txt` in the root of the project containing the
base64 encoding of the MRENCLAVE measurement. You will need to re-generate this
measurement anytime your source code or dependencies change.

## Publishing

```bash
make publish
```

## Integration

To get started, you will first need to:

1. Build your docker image and upload to a Docker/IPFS repository
2. Generate your MRENCLAVE measurement

Next, you will need to create a Function account for your given MRENCLAVE
measurement. Head over to [app.switchboard.xyz](https://app.switchboard.xyz) and
create a new function with your given repository and MRENCLAVE measurement.
