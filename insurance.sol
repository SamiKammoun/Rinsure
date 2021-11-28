// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract insurance{


    bytes32[] persons;
    uint[] cars;
    
    mapping(bytes32 => uint[]) public claims;//key is a person, claims is the value.
    // claims is an array of claims, each element of this array corresponds to the loss in dollars associated with this claim.
    mapping(bytes32 => bytes32[]) public subscriptions;//each person has his subscriptions registered in the blockchain.
    
    mapping(uint => bool) public carCheck;//checks if a car has an active insurance
    
    address[] private admins;//administrators

    constructor(){
        admins.push(msg.sender);//dev becomes admin
    }
    
    function isAdmin(address possibleAdmin) public view returns(bool){//returns true if transaction is requested from admin.
        for (uint i=0; i<admins.length; i++){
            if(admins[i]==possibleAdmin){
                return true;
            }
        }
        return false;
    }

    function giveAdminPrivilege(address newAdmin) public{//adding a new admin.
            require(isAdmin(msg.sender),"you're not autorised, you don't have admin permissions");
            admins.push(newAdmin);
    }

    function returnClaims(bytes32 person) public view returns(uint[] memory){//returns all the claims issued by this person.
            require(isAdmin(msg.sender),"you're not autorised, you don't have admin permissions");
            return claims[person];
    }

    function carIsGood(uint car) public returns(bool){//check if a car is authorized for insurance (double dipping)
        require(isAdmin(msg.sender),"you're not autorised, you don't have admin permissions");
        for (uint i=0; i<cars.length; i++){
            if(cars[i]==car){//car exists already
               if(carCheck[car]){
                    return false;
                } 
                return true;
            }
        }
        cars.push(car);
        return true;
    }

    function addEntry(bytes32 person,uint car,bytes32 subscriptionCompany) public {//adds a record of subscription.
        require(isAdmin(msg.sender),"you're not autorised, you don't have admin permissions");
        require(carIsGood(car),"car is already registered in insurance");
        bool b = true;
        for (uint i=0; i<persons.length; i++){
            if(persons[i]==person){
                subscriptions[person].push(subscriptionCompany); 
                b = false;
                break;
            }
        }
        if(b){
            persons.push(person);
            subscriptions[person]=[subscriptionCompany];
            claims[person]=[0];
        }

    }
    function addClaim(bytes32 person,uint value) public {//adds a claim to the blockchain.
        require(isAdmin(msg.sender),"you're not autorised, you don't have admin permissions");
        claims[person].push(value);
    }
}
