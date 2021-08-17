type MyAddress is address;
contract C {
    function id(MyAddress a) external returns (MyAddress b) {
        b = a;
    }
    function unwrap(MyAddress a) external returns (address b) {
        b = address(a);
    }
    function wrap(address a) external returns (MyAddress b) {
        b = MyAddress(a);
    }
}
// ====
// compileViaYul: also
// ----
// id(address): 5 -> 5
// id(address): 0xffffffffffffffffffffffffffffffffffffffff -> 0xffffffffffffffffffffffffffffffffffffffff
// id(address): 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff -> FAILURE
// unwrap(address): 5 -> 5
// unwrap(address): 0xffffffffffffffffffffffffffffffffffffffff -> 0xffffffffffffffffffffffffffffffffffffffff
// unwrap(address): 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff -> FAILURE
// wrap(address): 5 -> 5
// wrap(address): 0xffffffffffffffffffffffffffffffffffffffff -> 0xffffffffffffffffffffffffffffffffffffffff
// wrap(address): 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff -> FAILURE
