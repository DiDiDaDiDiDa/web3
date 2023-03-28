
<script setup>
import {ref,defineProps } from 'vue'
const props=defineProps(['wallet-info'])
console.log(props.walletInfo)

</script>

<template>
    <div v-for="item in props.walletInfo">hello</div>
</template>
    

<style lang="less">
</style>