type MyUint is uint;
type MyAddress is address;


function f() pure {
    MyUint x = MyUint(-1);
    x;
    MyAddress a = MyAddress(-1);
    a;
}
// ----
// TypeError 9640: (85-95): Explicit type conversion not allowed from "int_const -1" to "user defined type MyUint".
// TypeError 9640: (122-135): Explicit type conversion not allowed from "int_const -1" to "user defined type MyAddress".
