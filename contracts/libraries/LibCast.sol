// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.26;

import {SetValue} from "../facets/msca/utils/Constants.sol";
import {FunctionReference} from "./LibFunctionReference.sol";

/// @title Cast Library
/// @notice Library for various data type conversions.
library LibCast {
    /// @dev Input array is not verified. If called with non FunctionReference type array input, return data will
    /// be incorrect.
    function toFunctionReferenceArray(
        SetValue[] memory vals
    ) internal pure returns (FunctionReference[] memory ret) {
        assembly ("memory-safe") {
            ret := vals
        }
    }

    /// @dev Input array is not verified. If used with non address type array input, return data will be incorrect.
    function toAddressArray(
        SetValue[] memory values
    ) internal pure returns (address[] memory addresses) {
        bytes32[] memory valuesBytes;

        assembly ("memory-safe") {
            valuesBytes := values
        }

        uint256 length = values.length;
        for (uint256 i = 0; i < length; ++i) {
            valuesBytes[i] >>= 96;
        }

        assembly ("memory-safe") {
            addresses := valuesBytes
        }

        return addresses;
    }

    function toSetValue(
        FunctionReference functionReference
    ) internal pure returns (SetValue) {
        return
            SetValue.wrap(bytes30(FunctionReference.unwrap(functionReference)));
    }

    function toSetValue(address value) internal pure returns (SetValue) {
        return SetValue.wrap(bytes30(bytes20(value)));
    }
}
