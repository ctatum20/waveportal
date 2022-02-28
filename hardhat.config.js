require("@nomiclabs/hardhat-waffle");
require('dotenv').config();

console.log(process.env);

module.exports = {
  solidity: "0.8.0",
  networks: {
    rinkeby: {
      url: process.env.STAGING_ALCHEMY_KEY, //my alchemy API url
      accounts: [process.env.PRIVATE_KEY]
    },
    mainnet: {
      chainid: 1,
      url: process.env.PROD_ALCHEMY_KEY,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
