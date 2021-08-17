type MyAddress is address;

contract C {
    MyAddress[] public addresses;
    function f(MyAddress[] calldata _addresses) external {
        for (uint i = 0; i < _addresses.length; i++) {
            address(_addresses[i]).call("test");
        }
        addresses = _addresses;
    }
    function g(MyAddress[] memory _addresses) external {
        for (uint i = 0; i < _addresses.length; i++) {
            address(_addresses[i]).call("test");
        }
        addresses = _addresses;
    }
    function test_f() external returns (bool) {
        clean();
        MyAddress[] memory test = new MyAddress[](3);
        test[0] = MyAddress(address(1));
        test[1] = MyAddress(address(2));
        test[2] = MyAddress(address(3));
        this.f(test);
        test_equality(test);
        return true;
    }
    function test_g() external returns (bool) {
        clean();
        MyAddress[] memory test = new MyAddress[](5);
        test[0] = MyAddress(address(1));
        test[1] = MyAddress(address(11));
        test[2] = MyAddress(address(12));
        test[3] = MyAddress(address(13));
        test[4] = MyAddress(address(14));
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
            require(address(_addresses[i]) == address(addresses[i]));
        }
    }
}
// ====
// compileViaYul: also
// ----
// test_f() -> true
// gas irOptimized: 96989271
// gas legacy: 96989510
// gas legacyOptimized: 96989134
// test_g() -> true
// gas irOptimized: 93543
// gas legacy: 98234
// gas legacyOptimized: 93755
// addresses(uint256): 0 -> 1
// addresses(uint256): 1 -> 11
// addresses(uint256): 3 -> 13
// addresses(uint256): 4 -> 14
// addresses(uint256): 5 -> FAILURE
