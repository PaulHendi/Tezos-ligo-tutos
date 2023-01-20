type storage = tez

type parameter =
  Deposit 
| Withdraw 

type return = operation list * storage

let ownerAddress : address = "tz1WuWJ98ZCtgBhfVF4UDucCeYvJbELqbfck" 

// Two entrypoints
let deposit(balance: storage) = 
  let balance = balance + Tezos.get_amount() in
  [], balance 

let withdraw(balance: storage) = 
  if Tezos.get_sender() <> ownerAddress 
  then (failwith("Not owner")) 
  else (
    let amount : tez = balance in
    let balance = 0tez in 
    let receiver : unit contract =
      match (Tezos.get_contract_opt (Tezos.get_sender()) : unit contract option) with
        Some contract -> contract
      | None -> (failwith "Contract not found." : unit contract) in
    
    let withdrawOperation : operation = Tezos.transaction unit amount receiver in
    [withdrawOperation], balance)
  

(* Main access point that dispatches to the entrypoints according to
   the smart contract parameter. *)
let main (action, balance : parameter * storage) : return =
 (match action with
   Deposit() -> deposit(balance)
 | Withdraw() -> withdraw(balance)
 )
