type MyUint is uint;
type MyAddress is address;

function f() pure {
    MyUint x = MyUint(5);
    x;
    MyAddress a = MyAddress(address(5));
    a;
}
// ----
// TypeError 9640: (84-93): Explicit type conversion not allowed from "int_const 5" to "user defined type MyUint".
// TypeError 9640: (120-141): Explicit type conversion not allowed from "address" to "user defined type MyAddress".
