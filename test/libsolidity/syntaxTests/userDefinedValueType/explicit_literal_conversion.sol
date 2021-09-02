type MyAddress is address;
type MyUInt8 is uint8;

function f() pure {
    MyAddress a = MyAddress(5);
    MyUInt8 b = MyUInt8(-5);
    MyUInt8 b = MyUInt8(500);
}
// ----
// DeclarationError 2333: (136-145): Identifier already declared.
// TypeError 9640: (89-101): Explicit type conversion not allowed from "int_const 5" to "user defined type MyAddress".
// TypeError 9640: (119-130): Explicit type conversion not allowed from "int_const -5" to "user defined type MyUInt8".
// TypeError 9640: (148-160): Explicit type conversion not allowed from "int_const 500" to "user defined type MyUInt8".
