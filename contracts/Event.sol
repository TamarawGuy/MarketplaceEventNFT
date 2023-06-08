// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Event is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint public saleStart;
    uint public saleEnd;
    uint public ticketsPrice;
    uint public maxTickets;
    string public metadata;
    address public randomWinner;

    constructor(
        uint _saleStart,
        uint _saleEnd,
        uint _ticketsPrice,
        uint _maxTickets,
        string memory _metadata,
        address _owner
    ) ERC721("MyToken", "MTK") {
        require(_ticketsPrice > 0, "Invalid price");
        require(_saleEnd > _saleStart, "Invalid data");
        saleStart = _saleStart;
        saleEnd = _saleEnd;
        ticketsPrice = _ticketsPrice;
        maxTickets = _maxTickets;
        metadata = _metadata;
        _transferOwnership(_owner);
    }

    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _safeMint(address to, string memory uri) private {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    /**
     * Mint new NFTs and receive payment
     * @param _ticketAmount How many NFTs to mint
     */
    function buyTicket(uint _ticketAmount) external payable {
        require(_ticketAmount <= 50, "Max 50 tickets");
        require(
            _ticketAmount * ticketsPrice == msg.value,
            "Insufficient value"
        );

        if (maxTickets > 0) {
            require(
                _tokenIdCounter.current() + _ticketAmount <= 50,
                "Too many NFTs"
            );
        }

        for (uint i = 0; i < _ticketAmount; i++) {
            _safeMint(msg.sender, "mno dobre");
        }
    }

    function withdraw() external onlyOwner {
        require(block.timestamp > saleEnd, "Too early");
        payable(owner()).transfer(address(this).balance);
        _chooseRandomWinner();
    }

    function _chooseRandomWinner() internal {
        require(randomWinner == address(0), "Already chosen");
        randomWinner = _ownerOf(
            (block.prevrandao % _tokenIdCounter.current()) - 1
        );
        _safeMint(randomWinner, "mno dobre");
    }
}
