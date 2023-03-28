
<script setup>
import {ref,onMounted } from 'vue'
import { Button } from 'vant'
import ButtonVue from './components/Button.vue'
import AccountList from './components/AccountList.vue'
import store2 from "store2"

const walletInfo=ref(null)

onMounted(()=>{
  walletInfo.value=store2.get("walletInfo")||[]
  console.log(walletInfo.value,"=====")
})

</script>
<template>
  <ButtonVue></ButtonVue>
  <AccountList :wallet-info='walletInfo'></AccountList>

</template>

<style lang="less">
</style>
