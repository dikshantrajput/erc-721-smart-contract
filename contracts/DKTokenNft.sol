//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract DKTokenNft is ERC721{
    address public owner;
    uint256 public immutable totalSupply = 100;
    uint256 private tokenId;

    struct Token{
        string name;
        uint256 age;
        uint256 weight;
    }

    Token[] public tokens;
    
    mapping (uint256 => string) private tokenImageURIs;
    mapping (address => mapping(uint256 => uint256)) private tokenHolders;
    mapping (uint256 => uint256) private tokenIndex;

    event GenerateToken(uint256 indexed _tokenId, address indexed _to);

    constructor() ERC721("Person NFT","PN"){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "err : not the owner");
        _;
    }

    function getImageURI(uint256 _tokenId) public view returns (string memory){
        require(_exists(_tokenId),"err : token does not exists");
        return tokenImageURIs[_tokenId];
    }

    function getToken(uint256 _tokenId) public view returns (Token memory){
        require(_exists(_tokenId),"err : token does not exists");
        return tokens[_tokenId - 1];
    }

    receive() external payable {}

    function getUserTokens() public view returns (uint256[] memory){
        uint256 len = uint256(balanceOf(msg.sender));
        uint256[] memory ids = new uint256[](len);
        
        for(uint256 i = 0; i < len; i++){
            ids[i] = tokenHolders[msg.sender][i];
        }

        return ids;
    }

     function _beforeTokenTransfer(address _from, address _to, uint256 _tokenCardId) internal override{
        if(_from != address(0)){

            uint256 _tokenId = uint256(_tokenCardId);
            uint256 lastTokenIndex = uint256(balanceOf(_from) - 1);
            uint256 fromTokenIndex = tokenIndex[_tokenId];

            if(lastTokenIndex != fromTokenIndex){
                uint256 tempCardId = tokenHolders[_from][lastTokenIndex];
                tokenHolders[_from][fromTokenIndex] = tempCardId;
                tokenIndex[tempCardId] = fromTokenIndex;
            }

            delete tokenHolders[_from][lastTokenIndex];
            delete tokenIndex[_tokenId];

            uint256 toLastTokenIndex = uint256(balanceOf(_to));
            tokenHolders[_to][toLastTokenIndex] = _tokenId;
            tokenIndex[_tokenId] = toLastTokenIndex;

        }
    }

    function generateToken(string memory _name, uint256 _age, uint256 _weight, address _to, string memory _uri) public onlyOwner{
        require(tokenId + 1 < totalSupply,"err : total supply reached");
        Token memory t = Token(_name,_age,_weight);
        _safeMint(_to,tokenId + 1);
        tokenId++;
        tokens.push(t);
        emit GenerateToken(tokenId,_to);

        uint256 lastIndex = uint256(balanceOf(_to) - 1);
        tokenHolders[_to][lastIndex] = tokenId;
        tokenIndex[tokenId] = lastIndex;

        tokenImageURIs[tokenId] = _uri;
    }

}
