// Implementation of OpenZepplin's
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
// using user defined value types.

contract Ownable {
    type Owner is address;
    Owner public owner = wrap(msg.sender);
    error OnlyOwner();
    modifier onlyOwner() {
        if (unwrap(owner) != msg.sender)
            revert OnlyOwner();

        _;
    }
    event OwnershipTransferred(Owner indexed previousOwner, Owner indexed newOwner);
    function setOwner(Owner newOwner) onlyOwner external {
        emit OwnershipTransferred({previousOwner: owner, newOwner: newOwner});
        owner = newOwner;
    }
    function renounceOwnership() onlyOwner external {
        owner = wrap(address(0));
    }

    function wrap(address x) internal pure returns (Owner y) { assembly { y := x } }
    function unwrap(Owner x) internal pure returns (address y) { assembly { y := x } }
}
// ====
// compileViaYul: also
// ----
// owner() -> 0x1212121212121212121212121212120000000012
// setOwner(address): 0x1212121212121212121212121212120000000012 ->
// ~ emit OwnershipTransferred(address,address): #0x1212121212121212121212121212120000000012, #0x1212121212121212121212121212120000000012
// renounceOwnership() ->
// owner() -> 0
// setOwner(address): 0x1212121212121212121212121212120000000012 -> FAILURE, hex"5fc483c5"
