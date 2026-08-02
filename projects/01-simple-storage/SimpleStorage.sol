//SPDX-License-Identifier:MIT
pragma solidity ^0.8.30;

contract SimpleStorage{
    //stores a single favorite number
    uint256 public favoriteNumber;// 0
    //stores a information about person
    struct Person{
        string name;
        uint256 favoriteNumber;
    }
    //List of all people
    Person[] public people;

    //store the favorite Number
    function store(uint256 _favoriteNumber)public{
        favoriteNumber = _favoriteNumber;
    }
    // Retrieve favorite number
    function retrieve()public view returns(uint256){
        return favoriteNumber;
    }


    function addPerson(string memory _name,uint256 _favoriteNumber)public{
        people.push(Person(_name,_favoriteNumber));
    }


}