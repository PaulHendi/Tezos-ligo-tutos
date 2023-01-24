#include "piggy_bank.mligo"

// First test to actually get the address of the owner
// We'll set the first bootstrap account to be the source
let test_get_account_that_originates = 
    let account = Test.nth_bootstrap_account(0) in
    Test.log(account)

// Test the deposit and withdrawal of the some tez by the owner
let test_piggy_bank = 
    let owner = Test.nth_bootstrap_account(0) in
    let bob = Test.nth_bootstrap_account(1) in
    let () = Test.set_source owner in

    // Originate contract
    let initial_storage = 0tez in
    let (taddr, _, _) = Test.originate main initial_storage 0tez in
    let contract = Test.to_contract(taddr) in 
    
    // Get current balance
    let balance_owner = Test.get_balance(owner) in 
    let () = Test.log("Current balance of owner : ", (balance_owner)) in 

    // Owner deposit 10 tez
    let _ = Test.transfer_to_contract_exn contract (Deposit()) 100000tez in 
    let balance_owner = Test.get_balance(owner) in 
    let () = Test.log("Balance of owner after deposit : ", (balance_owner)) in 

    // Owner deposit 10 tez
    let _ = Test.transfer_to_contract_exn contract (Withdraw()) 0tez in 
    let balance_owner = Test.get_balance(owner) in 
    let () = Test.log("Balance of owner after withdrawal : ", (balance_owner)) in

    // Bob didn't deposit and fails to withrdraw
    // TODO : find an equivalent to expect
    let () = Test.set_source bob in
    let  = Test.transfer_to_contract_exn contract (Withdraw()) 0tez
