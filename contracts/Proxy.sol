// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.16;

abstract contract Proxy {

    fallback() external payable {
        _willFallback();
    }
    
    function _implementation() internal view virtual returns (address);

    function _delegate(address _impl) internal {
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), _impl, 0, calldatasize(), 0, 0)
            returndatacopy(0,0,returndatasize())

            switch result
            case 0 { revert(0, returndatasize()) }
            case 1 { return(0, returndatasize()) }

        }
    }

    function _willFallback() internal virtual {}

    function _fallback() internal {
        _willFallback();
        _delegate(_implementation());
    } 
}