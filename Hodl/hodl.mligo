type balanceOf = (address, tez) map
type lockedUntil = (address, timestamp) map

type storage = {
    hodl_duration : int;   
    balance_of : balanceOf;
    locked_until : lockedUntil
}

type parameter = 
    Deposit 
|   Withdraw


type return = operation list * storage


let deposit(store: storage) = 
    let updatedbalance : balanceOf = 
        Map.update (Tezos.get_sender())  (Some(Tezos.get_amount())) store.balance_of in 
    
    let end_at: timestamp = Tezos.get_now() + store.hodl_duration in

    let updatedLockedUntil : lockedUntil = 
        Map.update (Tezos.get_sender())  (Some(end_at)) store.locked_until in 
        

    [], {hodl_duration = store.hodl_duration; balance_of = updatedbalance; locked_until = updatedLockedUntil}


let withdraw(store: storage) = 

    let balance_user_opt: tez option = Map.find_opt (Tezos.get_sender()) store.balance_of in

    let balance_user : tez =
        match balance_user_opt with 
             Some(bal)     -> bal
        |    None          -> (failwith "No balance in the contract" : tez) in  // Should be failsafewith but cannot figure out how to do it yet


    let curr_time: timestamp = Tezos.get_now() in
    let locked_until_user_opt: timestamp option = Map.find_opt (Tezos.get_sender()) store.locked_until in
    let locked_until_user: timestamp = Option.unopt (locked_until_user_opt) in // Should not be None

    if locked_until_user < curr_time then failwith "Too soon to withdraw" 
    else 
        let receiver : unit contract =
            match (Tezos.get_contract_opt (Tezos.get_sender()) : unit contract option) with
                Some contract -> contract
            |   None -> (failwith "Contract not found." : unit contract) in
        
        let withdrawOperation : operation = Tezos.transaction unit balance_user receiver in
    
    let updatedBalance : balanceOf = Map.remove (Tezos.get_sender()) store.balance_of in 
    let updatedLockedUntil : lockedUntil = Map.remove (Tezos.get_sender()) store.locked_until in 


    [withdrawOperation], {hodl_duration = store.hodl_duration; balance_of = updatedBalance; locked_until = updatedLockedUntil}

 

(* Main access point that dispatches to the entrypoints according to
   the smart contract parameter. *)
let main (action, store : parameter * storage) : return =
 (match action with
   Deposit() -> deposit(store)
 | Withdraw() -> withdraw(store)
 )
