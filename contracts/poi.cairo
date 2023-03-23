%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address

struct StudentWallet {
    wallet_address_low: felt,
    wallet_address_high: felt,
}

@storage_var
func student_wallets(program: felt, index: felt) -> (student: StudentWallet) {
}

@storage_var
func program_students_number(program: felt) -> (number: felt) {
}

@storage_var
func owner() -> (res: felt) {
}

@constructor
func constructor {
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} () {
    let (caller_address) = get_caller_address();
    owner.write(value=caller_address);
    return ();
}

@external
func register_student {
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} (program: felt, wallet: StudentWallet) {
    let (number) = program_students_number.read(program);

    program_students_number.write(program, number + 1);
    student_wallets.write(program, number, wallet);

    return ();
}

@view
func get_owner {
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} () -> (address: felt) {
    let (address) = owner.read();
    return (address=address);
}

@view 
func get_students_count_by_program {
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} (program: felt) -> (count: felt) {
    let (length) = program_students_number.read(program);
    return (count=length);
}

@view 
func get_student_wallet {
    syscall_ptr: felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr,
} (program: felt, index: felt) -> (wallet: StudentWallet) {
    let (wallet) = student_wallets.read(program, index);
    return (wallet=wallet);
}