// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "./Context.sol";

abstract contract Ownable is Context{
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner , address indexed newOwner);

    constructor(){
        _transferOwnership(_msgSender());

    }


    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address){
        return _owner;
    }

    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(),"Caller is not the owner");
    }


    function renouncedOwnership() public virtual onlyOwner{
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner{
        require(newOwner != address(0),"Cannot transfer to the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual{
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}