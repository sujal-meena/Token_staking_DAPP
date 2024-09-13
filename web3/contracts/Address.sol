// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

library Address{
    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0; //return true or false
    }

    function sendValue(address payable recipient , uint256 amount) internal {
        require(address(this).balance >=amount , "Address : Insufficient Balance");
        
        (bool success , ) = recipient.call{value:amount}("");  //balance in wallet should be greater than amount
        require(success , "Address : Unable to send value");
        }

    function functioncall(address target , bytes memory data) internal returns (bytes memory){  // passing address as bytes instead of string ,because it cost less gas fee

    return functionCall(target , data ,"Address : Transaction Failed!");

    }

    function functionCall(
        address target, bytes memory data , string memory errorMessage
    ) internal returns (bytes memory)
    {
        return functionCallWithValue(target , data , 0 , errorMessage);

    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    )internal returns(bytes memory){
        return functionCallWithValue(target , data , value , "Address : Transaction Failed!");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value , string memory errorMessage)internal returns (bytes memory){
        require(address(this).balance >= value , "Address : Insufficient balance");
        require(isContract(target),"Address call to non-contract");

        (bool success , bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success,returndata,errorMessage);
    }

    function functionStaticCall(address target , bytes memory data) internal view returns(bytes memory){
        return functionStaticCall(target, data,"Address:Low-Level static call failed");
    }

    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory){
        require(isContract(target),"Address : static call to non-contract");

        (bool success , bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success,returndata,errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory){
        return functionDelegateCall(target, data,"Address : low-level delegate call failed");
    }

    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns(bytes memory){
        require(isContract(target),"Address : delegate call to non-contract");

        (bool success , bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success,returndata,errorMessage);
    }

    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory){
        if(success){
            return returndata;
        }
        else{
            if (returndata.length > 0){
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32,returndata),returndata_size)
                }
            }else{
                revert(errorMessage);
            }
        }
    }



    

}