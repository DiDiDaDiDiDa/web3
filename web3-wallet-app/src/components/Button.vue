
<script setup>
import {ref} from 'vue'
import {showNotify} from 'vant'
import "vant/es/dialog/style"
import "vant/es/notify/style"
import * as bip39 from 'bip39'

import ethWallet ,{ hdkey }from "ethereumjs-wallet"
import store2 from "store2"

const show = ref(false)
const password = ref('')
const mnomonic= ref('')
const mnomonicNew= ref('')
const showMn=ref(false)
const showMnDialog=ref(false)



const createWallet=() =>{
    show.value = true
}
const confirmPassword =()=>{
    if (password.value.length==0){
        showNotify({ type: 'danger', message: '请输入密码' });
    }else{
        const walletInfo = store2.get("walletInfo")
        mnomonic.value=walletInfo
        ?walletInfo[0]['mnomonic']
        :bip39.generateMnemonic()
        if(walletInfo){
            confirmMn()
        }else{
            showMn.value=true
        }
    }
}
const confirmSaveNmonic=()=>{
    showMnDialog.value=true
}
const confirmMn=async()=>{
        showMn.value=false
        const storeWallet = store2.get("walletInfo")||[]
        if(mnomonic.value!==mnomonicNew.value&&storeWallet.length==0){
            return
        }else{
            const seed=await bip39.mnemonicToSeed(mnomonic.value)
            const hdWallet=hdkey.fromMasterSeed(seed)
            const addressIndex=storeWallet.length
            const keyPair=hdWallet.derivePath(`m/44'/60'/0'/0/${addressIndex}`)
            const wallet=keyPair.getWallet()

            const lowerCaseAddress=wallet.getAddressString()
            const CheckSumAddress=wallet.getChecksumAddressString()
            const privKey=wallet.getPrivateKey().toString("hex")
            const keyStore=await wallet.toV3(password.value)
            const walletObject={
                id:addressIndex,
                address:lowerCaseAddress,
                privateKey:privKey,
                keyStore,
                mnomonic:mnomonic.value,
                balance:0,
            }
            storeWallet.push(walletObject)
            store2("walletInfo",storeWallet)
        }
}
</script>
<template>
    <van-space>
        <van-button type="primary" @click="createWallet">创建钱包</van-button>
        <van-button type="primary">导入钱包</van-button>
    </van-space>
    
    <van-dialog v-model:show="show" 
                title="请输入密码" 
                show-cancel-button
                @confirm="confirmPassword">
        <van-cell-group inset>
            <van-field v-model="password"
                label="密码"
                placeholder="请输入密码" 
                type="password"
                />
        </van-cell-group>
    </van-dialog>
    
    <template  v-if="showMn">
        <p>
            {{ mnomonic }}
        </p>
        <van-button size="mini" @click="confirmSaveNmonic">
            我已经保存了
        </van-button>
        <van-dialog v-model:show="showMnDialog" 
                title="请输入助记词" 
                show-cancel-button
                @confirm="confirmMn">
        <van-cell-group inset>
            <van-field v-model="mnomonicNew"
                label="助记词"
                placeholder="请输入助记词" 
                type="text"
                />
        </van-cell-group>
    </van-dialog>
    </template>
    
</template>
<style lang="less">
body {
    padding: 10px;
}
p{
    user-select: all;
}
</style>
