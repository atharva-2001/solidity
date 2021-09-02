type MyUInt8 is uint8;
type MyInt8 is int8;
type MyUInt16 is uint16;

function wrap8(uint8 x) pure returns (MyUInt8 y) { assembly { y := x } }
function wrapi8(int8 x) pure returns (MyInt8 y) { assembly { y := x } }
function wrap16(uint16 x) pure returns (MyUInt16 y) { assembly { y := x } }
function unwrap8(MyUInt8 x) pure returns (uint8 y) { assembly { y := x } }
function unwrapi8(MyInt8 x) pure returns (int8 y) { assembly { y := x } }
function unwrap16(MyUInt16 x) pure returns (uint16 y) { assembly { y := x } }

contract C {
    function f(uint a) external returns(MyUInt8) {
        return wrap8(uint8(a));
    }
    function g(uint a) external returns(MyInt8) {
        return wrapi8(int8(int(a)));
    }
    function h(MyUInt8 a) external returns (MyInt8) {
        return wrapi8(int8(unwrap8(a)));
    }
    function j(MyUInt8 a) external returns (uint) {
        return unwrap8(a);
    }
    function k(MyUInt8 a) external returns (MyUInt16) {
        return wrap16(unwrap8(a));
    }
    function m(MyUInt16 a) external returns (MyUInt8) {
        return wrap8(uint8(unwrap16(a)));
    }
}

// ====
// compileViaYul: also
// ----
// f(uint256): 1 -> 1
// f(uint256): 2 -> 2
// f(uint256): 257 -> 1
// g(uint256): 1 -> 1
// g(uint256): 2 -> 2
// g(uint256): 255 -> -1
// g(uint256): 257 -> 1
// h(uint8): 1 -> 1
// h(uint8): 2 -> 2
// h(uint8): 255 -> -1
// h(uint8): 257 -> FAILURE
// j(uint8): 1 -> 1
// j(uint8): 2 -> 2
// j(uint8): 255 -> 0xff
// j(uint8): 257 -> FAILURE
// k(uint8): 1 -> 1
// k(uint8): 2 -> 2
// k(uint8): 255 -> 0xff
// k(uint8): 257 -> FAILURE
// m(uint16): 1 -> 1
// m(uint16): 2 -> 2
// m(uint16): 255 -> 0xff
// m(uint16): 257 -> 1
