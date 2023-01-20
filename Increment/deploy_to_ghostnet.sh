octez-client --endpoint https://rpc.ghostnet.teztnets.xyz config update
octez-client gen keys alice
octez-client originate contract increment \
              transferring 0 from alice \
              running increment.tz \
              --init 10 --burn-cap 0.1