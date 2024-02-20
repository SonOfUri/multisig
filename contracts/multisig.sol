// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;


contract multiSig{
    // The array of signers addresses 
    address[] public signers;
    // Mapping of address to boolean to mark an address as signers
    mapping(address => bool) public isSigner;
    // The interger that holds the number that makes up a quorum
    uint public quorum;

    // The struct of transaction
    struct  Transaction {
        address to;
        uint value;
        bool isExecuted;
        mapping(address => bool) isConfirmed;
        uint confirmations;
    }

    // An array of transaction structs called transactions
    Transaction[] public transactions;

    // EVENTS
    // Deposit Event
    event Deposit(address indexed sender, uint amoount, uint balance);
    // Submit Transaction Event 
    event submitTx(address indexed signers, uint indexed txIndex, address indexed to, uint value);
    // Confirm transaction Event
    event confirmTx(address indexed signers, uint indexed txIndex);
    // Execute transaction Event
    event executeTx(address indexed signers, uint indexed txIndex);

    modifier onlysigners() {
        // Checking if the msg.sender's address is captured in the mapping called isSigner
        require(isSigner[msg.sender], "You are not the signers");
        _;
    }

    // Constructor for the multiSig contract
    constructor(address[] memory _signer, uint _quorum){
         require(_signer.length > 0, "signers required");
         require(_quorum > 2, "Must requiire at least 2 signers");
         require(_quorum <= _signer.length, "Quorun Cannot be more than signers");

         for(uint i=0; i < _signer.length; i++){
           address signer = _signer[i];
            require(signer != address(0), "Invalid address");
            require(!isSigner[signer], "Address already exist");

            isSigner[signer] = true;
            signers.push(signer);
         }

         quorum = _quorum;
    }

    function deposit () public payable{
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    function submitTransaction(address _to, uint _value) public onlysigners {

        Transaction memory newTransaction = Transaction({
            to: _to,
            value: _value,
            isExecuted: false,
            isConfirmed: _isConfirmed,
            confirmations: 1
        });

        transactions.push(newTransaction);

        emit submitTx(msg.sender , transactions.length - 1, _to,  _value);
    }

    function approveransaction(uint _txIndex) public onlysigners{
        require(isSigner[msg.sender], "Not an signer");
        require(!Transaction.isConfirmed[msg.sender], "Transaction already confirmed");
    }

}