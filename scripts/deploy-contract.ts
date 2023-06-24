import hardhat from "hardhat";
import { starknet } from "hardhat";
import { Config } from "./config";

async function main() {
  const account = await getOZAccount();
  const contractFactory = await hardhat.starknet.getContractFactory("poi");
  await account.declare(contractFactory, { maxFee: 1e18 });
  const contract = await account.deploy(contractFactory, {
    owner: Config.contractOwner,
  });
  console.log("Deployed to:", contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

/**
 * Returns an instance of OZAccount. Expected to be deployed
 */
export async function getOZAccount() {
  return await starknet.OpenZeppelinAccount.getAccountFromAddress(
    Config.publicKey,
    Config.privateKey
  );
}
