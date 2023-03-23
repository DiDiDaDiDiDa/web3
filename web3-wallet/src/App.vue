<template>
  <van-button type="primary">主要按钮</van-button>
</template>

<script setup>
import { createApp } from 'vue'
import { Button } from 'vant'
import Web3 from 'web3'

const app = createApp()
app.use(Button)

// 创建实例，如果在支持以太坊的浏览器 "Web3.providers.givenProvider" 会被设置。
var web3 = new Web3(Web3.givenProvider || 'ws://some.local-or-remote.node:8546')
console.log(web3)
</script>

<style lang="less">

</style>
