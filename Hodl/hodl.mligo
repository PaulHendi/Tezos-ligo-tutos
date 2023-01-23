type storage = {
    hodl_duration : nat;   
    balance_of : (address, nat) map;
    locked_until : (address, nat) map
}

type parameter = 
    Deposit 
|   Withdraw


type return = operation list * storage


let deposit(store: storage) = 
    let assign(m : store.balance_of) : store.balance_of = 
        Map.update((Tezos.get_sender()), (Some(Tezos.get_amount())), m) in 
    
    let locked_until = Tezos.get_now() + store.hodl_duration  in
    
    let assign(m : store.locked_until) : store.locked_until = 
        Map.update(Tezos.get_sender(), Some(locked_until), m) in 

    [], store

let withdraw(store: storage) = 
    [], store

(* Main access point that dispatches to the entrypoints according to
   the smart contract parameter. *)
let main (action, store : parameter * storage) : return =
 (match action with
   Deposit() -> deposit(store)
 | Withdraw() -> withdraw(store)
 )
