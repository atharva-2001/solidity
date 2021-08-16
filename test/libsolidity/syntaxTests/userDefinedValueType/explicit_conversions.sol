type MyUint is uint;
type MyAddress is address;

function f() pure {
    MyUint x = MyUint(5);
    x;
    MyAddress a = MyAddress(address(5));
    a;
}
