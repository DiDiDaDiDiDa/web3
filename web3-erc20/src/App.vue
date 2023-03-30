<script setup>
import { ref, onMounted, computed } from "vue";
import Web3 from "web3";
import mtcJSON from "./contracts/MyToken.json";
const geerliWS =
  "wss://goerli.infura.io/ws/v3/e4f789009c9245eeaad1d93ce9d059bb";
const web3 = new Web3(Web3.givenProvider || geerliWS);

const mtcContract = new web3.eth.Contract(
  mtcJSON.abi,
  "0xCB5E7F8675c0a530cebDccF18D6CBcB03494BcC1"
);

// 代币信息
const name = ref("");
const symbol = ref("");
const totalSupply = ref("");
const balanceOf = ref(0);
const currentAccount = ref("");

// 转账信息
const toAdrress = ref("");
const amount = ref("");

const getCoinInfo = async () => {
  const account = await web3.eth.requestAccounts();
  currentAccount.value = account;

  name.value = await mtcContract.methods.name().call();
  symbol.value = await mtcContract.methods.symbol().call();
  totalSupply.value = await mtcContract.methods.totalSupply().call();
  balanceOf.value = await mtcContract.methods.balanceOf(account[0]).call();
};

const ts = computed(() => {
  return web3.utils.fromWei(totalSupply.value, "ether");
});
const bo = computed(() => {
  return web3.utils.fromWei(String(balanceOf.value), "ether");
});

onMounted(() => {
  getCoinInfo();
});

const send = () => {
  const weiAmount = web3.utils.toWei(amount.value, "ether");
  mtcContract.methods
    .transfer(toAdrress.value, weiAmount)
    .send({
      from: currentAccount.value[0],
    })
    .on("receipt", (res) => {
      console.log("交易成功！");
      console.log(res);
    });
};
</script>

<template>
  <h1>RABTC基本信息：</h1>
  <hr />
  <p>当前账号：{{ currentAccount }}</p>
  <p>代币名称：{{ name }}</p>
  <p>代币标识：{{ symbol }}</p>
  <p>发行量：{{ ts }}</p>
  <p>持有数量：{{ bo }}</p>
  <h1>转账操作：</h1>
  <hr />
  <p>转入地址：<input type="text" v-model="toAdrress" class="address" /></p>
  <p>转出金额：<input type="text" v-model="amount" /> R</p>
  <button @click="send">开始转账</button>
</template>

<style lang="less">
.address {
  width: 500px;
}
</style>
