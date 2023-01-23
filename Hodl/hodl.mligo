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
    [], store

(* Main access point that dispatches to the entrypoints according to
   the smart contract parameter. *)
let main (action, store : parameter * storage) : return =
 (match action with
   Deposit() -> deposit(store)
 | Withdraw() -> withdraw(store)
 )
