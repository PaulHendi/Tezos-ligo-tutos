octez-client --endpoint https://rpc.ghostnet.teztnets.xyz config update
octez-client import secret key owner SECRET_KEY
octez-client originate contract increment \
              transferring 0 from owner \
              running increment.tz \
              --init 10 --burn-cap 0.1

octez-client call increment from owner \
             --arg "(Left (Right 32))" \
             --burn-cap 0.1              