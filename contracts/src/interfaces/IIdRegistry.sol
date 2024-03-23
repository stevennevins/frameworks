// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

interface IIdRegistry {
    /**
     * @notice Maps each address to an fid, or zero if it does not own an fid.
     */
    function idOf(address owner) external view returns (uint256 fid);

    /**
     * @notice Maps each fid to the address that currently owns it.
     */
    function custodyOf(uint256 fid) external view returns (address owner);

    /**
     * @notice Maps each fid to an address that can initiate a recovery.
     */
    function recoveryOf(uint256 fid) external view returns (address recovery);

    /**
     * @notice Verify that a signature was produced by the custody address that owns an fid.
     *
     * @param custodyAddress   The address to check the signature of.
     * @param fid              The fid to check the signature of.
     * @param digest           The digest that was signed.
     * @param sig              The signature to check.
     *
     * @return isValid Whether provided signature is valid.
     */
    function verifyFidSignature(
        address custodyAddress,
        uint256 fid,
        bytes32 digest,
        bytes calldata sig
    ) external view returns (bool isValid);
}
