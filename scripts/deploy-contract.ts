import hardhat from "hardhat";
import { starknet } from "hardhat";

async function main() {
  const account = await getOZAccount();
  const contractFactory = await hardhat.starknet.getContractFactory("poi");
  await account.declare(contractFactory, { maxFee: 1e18 });
  const contract = await account.deploy(contractFactory);
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
    // address from previous step
    "0x26a9305844b65263360d6ea85aa1426a4e75e76a3247a876f8e68ef4c4b2067",
    // private key from previous step
    "0xd64583c27cc7443e2fc3ce912684bafecf8587abf08d054531d3d2c96d6bd63"
  );
}
