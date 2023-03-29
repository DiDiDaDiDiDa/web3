<script setup>
import { ref } from 'vue';
import { Divider,Button } from 'vant';
import Web3 from 'web3'
import { StringDecoder } from 'string_decoder';
import Tx from 'ethereumjs-tx'
var web3 = new Web3(Web3.givenProvider || 'wss://goerli.infura.io/ws/v3/6feae88a0990434bb7deb990ecc807fd')

// 创建账户
// const account=web3.eth.accounts.create('cde34rfv')
// address: '0xD0116FbBC981Cf10F44ebb0Fc5939c08d32F71D3', privateKey: '0x6a5aa7960269a0849c1229ad8610dc0ed6781ccd4500ba84a0df8582ed56fdba'
const address =  ref('0xD0116FbBC981Cf10F44ebb0Fc5939c08d32F71D3')
const privateKey = ref('0x6a5aa7960269a0849c1229ad8610dc0ed6781ccd4500ba84a0df8582ed56fdba')
const mount=ref(0)
// 获取余额的API
web3.eth.getBalance(address.value).then((resp)=>{
    mount.value=web3.utils.fromWei(resp,"ether")
})

// 单位转换
// console.log(web3.utils.toWei("1","ether"))

// 转账函数
const send=async()=>{
    // 构建转账参数
    // 获取账户交易次数
    const nonce =await web3.eth.getTransactionCount(address.value);

    console.log(nonce)
    // 获取预计转账交易费gas
    const gasPrice =await web3.eth.getGasPrice()
    // 转账金额，以wei为单位
    const value=web3.utils.toWei("0.04")

    const rawTx={
        from:address.value,
        to:'0xCB5E7F8675c0a530cebDccF18D6CBcB03494BcC1',
        nonce,
        gasPrice,
        value,
        data:"0x00000000",
    }

    //生成serializedTx
    // 转化私钥
    const privKey =Buffer(privateKey.value.slice(2),"hex")
    // console.log(privKey.toString("hex"))

    // gas估值
    const gas=await web3.eth.estimateGas(rawTx)
    rawTx.gas=gas
    // 使用ethereumjs-tx进行私钥加密
    const tx=new Tx(rawTx)
    tx.sign(privKey)
    const serializedTx ='0x'+tx.serialize().toString("hex")
    // 开始转账
    const trans=web3.eth.sendSignedTransaction(serializedTx)
    trans.on("transactionHash",(txid)=>{
        console.log('交易ID：',txid)
        console.log(`http://goerli.etherscan.io/tx/${txid}`)
    })
    // 只要有一个节点确认就触发交易
    trans.on("receipt",(res)=>{
        console.log("第一个节点确认：",res)
    })
    trans.on("confirmation",(res)=>{
        console.log("第n个节点确认：",res)
    })
}
</script>
<template>
    <h1>账户信息：</h1>
    <p>地址：{{address}}</p>
    <p>私钥：{{privateKey}}</p>
    <p>余额：{{mount}}</p>
    <van-divider />
    <h1>转账操作：</h1>
    <van-button type="primary" @click="send">转账</van-button>
    
    <van-divider />
</template>
<style lang="less"></style>