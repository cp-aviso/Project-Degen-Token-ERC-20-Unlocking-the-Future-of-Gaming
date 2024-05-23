// SPDX-License-Identifier: MIT
// 1.Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
// 2.Transferring tokens: Players should be able to transfer their tokens to others.
// 3. Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
// 4. Checking token balance: Players should be able to check their token balance at any time.
// 5. Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.

// this program was run and compiled in https://remix.ethereum.org/
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    struct Item {
        string name;
        uint256 price;
    }

    mapping(string => Item) public items;

    constructor() ERC20("AvisoToken", "AVS") Ownable(msg.sender) {}

    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function redeemItem(string memory itemName) public {
        require(items[itemName].price > 0, "Item not found");
        require(balanceOf(msg.sender) >= items[itemName].price, "Insufficient balance");
        
        // Deduct the price of the item from the user's balance
        _burn(msg.sender, items[itemName].price);
        
        emit ItemRedeemed(msg.sender, itemName);
    }
      
    function addItem(string memory itemName, uint256 price) public onlyOwner {
        require(price > 0, "Price must be greater than zero");
        items[itemName] = Item(itemName, price);
    }

    event ItemRedeemed(address indexed user, string itemName);

     function burn(uint256 amount) public virtual {
        _burn(_msgSender(), amount);
    }

}
