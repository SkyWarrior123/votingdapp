
const hre = require("hardhat");

async function main() {

  const VotingDapp = await hre.ethers.getContractFactory("VotingDapp");
  const votingdapp = await VotingDapp.deploy(["0x50726f706f73616c204100000000000000000000000000000000000000000000","0x50726f706f73616c204200000000000000000000000000000000000000000000","0x50726f706f73616c204200000000000000000000000000000000000000000000"]);

  await votingdapp.deployed();

  console.log("VotingDapp deployed to:", votingdapp.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
