type MyInt is int;
contract C {
    function f() external returns (MyInt a) {
    }
    function g() external returns (MyInt b) {
        int x = 1;
        assembly { b := x }
    }
}
// ====
// compileViaYul: also
// ----
// f() -> 0
// g() -> 1
