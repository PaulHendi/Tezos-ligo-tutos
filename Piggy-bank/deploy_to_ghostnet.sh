octez-client --endpoint https://rpc.ghostnet.teztnets.xyz config update
octez-client import secret key owner SECRET_KEY
octez-client originate contract piggy_bank \
              transferring 0 from owner \
              running piggy_bank.tz \
              --init 0 --burn-cap 0.12175

ligo compile parameter piggy_bank.mligo "Deposit()"        #  (Left Unit)


octez-client call piggy_bank from owner \
             --arg "(Left Unit)" \
             --burn-cap 0.1              


octez-client get balance for piggy_bank             


octez-client transfer 5 from owner to piggy_bank --burn-cap 0.1 --arg "(Left Unit)"

octez-client call piggy_bank from owner \
             --arg "(Right Unit)" \
             --burn-cap 0.1   