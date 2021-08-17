type MyAddress is address;
type MyUInt is uint;
function f() {
    MyAddress a = MyAddress(0);
    MyUInt b = MyUInt(0);
}
contract C {
    type MyAddress is address;
    type MyUInt is uint;
}

// ----
