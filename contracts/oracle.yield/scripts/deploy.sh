#!/bin/bash

# unlock wallet
cleos wallet unlock --password $(cat ~/eosio-wallet/.pass)

# create accounts
cleos create account eosio oracle.yield EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.yield EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio admin.yield EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio myprotocol EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio myvault EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio protocol1 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio protocol2 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio myoracle EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio eosio.token EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio tethertether EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio oracle.defi EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio delphioracle EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

# deploy
cleos set contract oracle.yield . oracle.yield.wasm oracle.yield.abi
cleos set contract eosio.token ../../external/eosio.token eosio.token.wasm eosio.token.abi
cleos set contract tethertether ../../external/eosio.token eosio.token.wasm eosio.token.abi
cleos set contract oracle.defi ../../external/oracle.defi oracle.defi.wasm oracle.defi.abi
cleos set contract delphioracle ../../external/delphioracle delphioracle.wasm delphioracle.abi

# permissions
cleos set account permission oracle.yield active --add-code

# create tokens
cleos push action eosio.token create '["eosio", "1000000000.0000 EOS"]' -p eosio.token
cleos push action eosio.token issue '["eosio", "1000000000.0000 EOS", "init"]' -p eosio

cleos push action tethertether create '["tethertether", "1000000000.0000 USDT"]' -p tethertether
cleos push action tethertether issue '["tethertether", "1000000000.0000 USDT", "init"]' -p tethertether

# transfer tokens
cleos transfer eosio myprotocol "300000.0000 EOS"
cleos transfer tethertether myprotocol "300000.0000 USDT" --contract tethertether
cleos transfer tethertether myvault "500000.0000 USDT" --contract tethertether
cleos transfer tethertether protocol1 "500000.0000 USDT" --contract tethertether
cleos transfer eosio protocol2 "250000.0000 EOS"
cleos transfer eosio oracle.yield "10000.0000 EOS"

# setup oracle
cleos push action oracle.defi setprice '[1, "eosio.token", "4,EOS", 13869]' -p oracle.defi
cleos push action delphioracle setpair '["eosusd", "4,EOS", "eosio.token", 4]' -p delphioracle
cleos push action delphioracle setprice '["eosusd", 13869]' -p delphioracle