#!/bin/bash

blanc++ oracle.yield.cpp -I include

if [ ! -f "./include/eosio.token/eosio.token.wasm" ]; then
    blanc++ ./include/eosio.token/eosio.token.cpp -I include -o include/eosio.token/eosio.token.wasm
fi

# unlock wallet & deploy
cleos wallet unlock --password $(cat ~/eosio-wallet/.pass)
cleos set contract oracle.yield . oracle.yield.wasm oracle.yield.abi