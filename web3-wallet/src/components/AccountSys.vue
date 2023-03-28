<script setup>
    import * as bip39 from "bip39"
    import { ref } from 'vue';
    import { Wallet } from "web3-eth-accounts"
    import ethWallet ,{ hdkey }from "ethereumjs-wallet"
    import console from "console";
    import Web3 from 'web3';
    //创建助记词
    // const mnemonic = bip39.generateMnemonic()
    const mnemonic =  ref('marine poverty brick video gospel river enrich nest mango burst truth reopen')
  
    var path="",lowerCaseAddress="",privKey=""
    // 生成密钥对
    const genMnemonic=async () =>{
        const seed=await bip39.mnemonicToSeed(mnemonic.value)
        const hdWallet=hdkey.fromMasterSeed(seed)
        path="m/44'/60'/0'/0/0"
        const keyPair = hdWallet.derivePath(path)
        // 获取私钥
        // 获取钱包对象
        const wallet =keyPair.getWallet();
        // 、获取钱包地址
        lowerCaseAddress = wallet.getAddressString()
        // 钱包的校验地址
        const checkAddress=wallet.getChecksumAddressString()
        //获取私钥
        privKey =wallet.getPrivateKey().toString("hex")
        const password ="cde34rfv"
        // 导出keyStore
        
        var web3 = new Web3(Web3.givenProvider || 'wss://goerli.infura.io/ws/v3/6feae88a0990434bb7deb990ecc807fd')

        const keyStore=web3.eth.accounts.encrypt(privKey,password)
        
        // console.log(JSON.stringify(keyStore))

        // 根据keyStore反推私钥
        const privKey1=web3.eth.accounts.decrypt(JSON.stringify(keyStore),password)
        // console.log(privKey1)

        // 通过私钥获取地址
        const privKey2=Buffer(privKey,"hex")
        const wallet3=ethWallet.fromPrivateKey(privKey2)
        const lowerCaseAddress2=wallet3.getAddressString()
        console.log(lowerCaseAddress2)


        
        
    }
    genMnemonic()
    // sleep(5000)

    
</script>
<template>
<p>
    助记词：{{ mnemonic }}
</p>
<p>
    路径：{{ path }}
</p>
<p>
    地址：{{ lowerCaseAddress }}
</p>
<p>
    私钥：{{ privKey }}
</p>
</template>
<style lang="less"></style>