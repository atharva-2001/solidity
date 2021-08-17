type MyInt is int;
contract C {
    function f() external returns (MyInt a) {
    }
    function g() external returns (MyInt b) {
        b = MyInt(int(1));
    }
}
// ====
// compileViaYul: also
// ----
// f() -> 0
// g() -> 1
