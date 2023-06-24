%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_not_zero
from starkware.starknet.common.syscalls import get_caller_address

struct StudentWallet {
    wallet_address_low: felt,
    wallet_address_high: felt,
}

struct ShortText {
    low: felt,
    high: felt,
}

struct Edition {
    edition_number: felt,
    venue: ShortText,
    photo_cid: ShortText,
    graduates_number: felt,
    wallets_number: felt,
}

@storage_var
func editions(index: felt) -> (edition: Edition) {
}

@storage_var
func editions_number() -> (number: felt) {
}

@storage_var
func student_wallets(edition_number: felt, index: felt) -> (wallet: StudentWallet) {
}

@storage_var
func contract_owner() -> (res: felt) {
}

@constructor
func constructor {
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} (owner: felt) {
    contract_owner.write(owner);
    return ();
}

@view
func get_owner {
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} () -> (address: felt) {
    let (address) = contract_owner.read();
    return (address=address);
}

func assert_only_owner {
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
} () {
    let (owner) = contract_owner.read();
    let (caller) = get_caller_address();
    with_attr error_message("Ownable: caller is the zero address") {
        assert_not_zero(caller);
    }
    with_attr error_message("Ownable: caller is not the owner") {
        assert owner = caller;
    }
    return ();
}

func register_students {
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} (edition_number: felt, wallet_index: felt, wallets_len: felt, wallets: StudentWallet*) {
    if (wallet_index == wallets_len) {
        return ();
    }

    student_wallets.write(edition_number, wallet_index, wallets[wallet_index]);
    register_students(edition_number, wallet_index + 1, wallets_len, wallets);

    return ();
}

@external
func add_edition {
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} (edition_number: felt, venue: ShortText, photo_cid: ShortText, graduates_number: felt, wallets_len: felt, wallets: StudentWallet*) {
    let (current_number) = editions_number.read();

    editions.write(current_number, Edition(edition_number, venue, photo_cid, graduates_number, wallets_number=wallets_len));
    editions_number.write(current_number + 1);
    register_students(edition_number, 0, wallets_len, wallets);

    return ();
}

@view 
func get_editions_count {
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} () -> (count: felt) {
    let (current_number) = editions_number.read();
    return (count=current_number);
}

@view 
func get_edition {
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} (edition_index: felt) -> (edition: Edition) {
    let (edition) = editions.read(edition_index);
    return (edition=edition);
}

@view 
func get_student_wallet {
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} (edition_number: felt, index: felt) -> (wallet: StudentWallet) {
    let (wallet) = student_wallets.read(edition_number, index);
    return (wallet=wallet);
}

@external
func update_edition_data {
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} (edition_index: felt, edition_number: felt, venue: ShortText, photo_cid: ShortText, graduates_number: felt, wallets_number: felt) {
    assert_only_owner();

    editions.write(edition_index, Edition(edition_number, venue, photo_cid, graduates_number, wallets_number));

    return ();
}

@external
func update_student_wallet {
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} (edition_number: felt, wallet_index: felt, wallet: StudentWallet) {
    assert_only_owner();

    student_wallets.write(edition_number, wallet_index, wallet);
    
    return ();
}