<template>
  <Web3Api></Web3Api>
</template>

<script setup>
import { createApp } from 'vue'
import { Button } from 'vant'
import Web3Api from "./components/web3Api.vue"

const app = createApp()
app.use(Button)

</script>

<style lang="less">

</style>
