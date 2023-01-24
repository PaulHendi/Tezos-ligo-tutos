#include "hodl.mligo" 

let test =
  let initial_storage: storage = {
      hodl_duration = 3600; 
      balance_of = Map.empty; 
      locked_until = Map.empty
    } in
  let (taddr, _, _) = Test.originate main  initial_storage 0tez in
  let contract = Test.to_contract(taddr) in
  let _ = Test.transfer_to_contract_exn contract (Deposit()) 1tez  in
  let () = Test.log("Storage", Test.get_storage(taddr)) in
  let () = Test.log("Balance contract", (Test.get_balance(taddr))) in
  let _ = Test.transfer_to_contract_exn contract (Withdraw()) 0tez in
  let () = Test.log("Balance contract", Tezos.get_balance(taddr)) in
  Test.log("Storage", Test.get_storage(taddr))
