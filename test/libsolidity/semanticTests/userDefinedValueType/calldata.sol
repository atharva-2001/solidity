type MyAddress is address;

function unwrap(MyAddress x) pure returns (address y) {
    assembly { y := x }
}

function wrap(address x) pure returns (MyAddress y) {
    assembly { y := x }
}

contract C {
    MyAddress[] public addresses;
    function f(MyAddress[] calldata _addresses) external {
        for (uint i = 0; i < _addresses.length; i++) {
            unwrap(_addresses[i]).call("test");
        }
        addresses = _addresses;
    }
    function g(MyAddress[] memory _addresses) external {
        for (uint i = 0; i < _addresses.length; i++) {
            unwrap(_addresses[i]).call("test");
        }
        addresses = _addresses;
    }
    function test_f() external returns (bool) {
        clean();
        MyAddress[] memory test = new MyAddress[](3);
        test[0] = wrap(address(1));
        test[1] = wrap(address(2));
        test[2] = wrap(address(3));
        this.f(test);
        test_equality(test);
        return true;
    }
    function test_g() external returns (bool) {
        clean();
        MyAddress[] memory test = new MyAddress[](5);
        test[0] = wrap(address(1));
        test[1] = wrap(address(11));
        test[2] = wrap(address(12));
        test[3] = wrap(address(13));
        test[4] = wrap(address(14));
        this.g(test);
        test_equality(test);
        return true;
    }
    function clean() internal {
        delete addresses;
    }
    function test_equality(MyAddress[] memory _addresses) internal view {
        require (_addresses.length == addresses.length);
        for (uint i = 0; i < _addresses.length; i++) {
            require(unwrap(_addresses[i]) == unwrap(addresses[i]));
        }
    }
}
// ====
// compileViaYul: also
// ----
// test_f() -> true
// gas irOptimized: 96989275
// gas legacy: 96989774
// gas legacyOptimized: 96989223
// test_g() -> true
// gas irOptimized: 93563
// gas legacy: 99094
// gas legacyOptimized: 93940
// addresses(uint256): 0 -> 1
// addresses(uint256): 1 -> 11
// addresses(uint256): 3 -> 13
// addresses(uint256): 4 -> 14
// addresses(uint256): 5 -> FAILURE
