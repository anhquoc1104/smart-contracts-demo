pragma solidity >=0.7.4 < 0.9.0;

contract Faucet {
    /* Variable */
    uint256 public numOfIndex;
    mapping(uint256 => address) public lutFunders;
    mapping(address => bool) public funders;

    // external: cho bên ngoài gọi vào
    // payable: fn có khả năng thanh toán
    receive() external payable{}

    function addFunds() external payable{
        address funder = msg.sender;

        if(!funders[funder]){
            uint256 index = numOfIndex++;
            funders[funder] = true;
            lutFunders[index] = funder;
        }
    }

    function getFundersIndex(uint256 index) external view returns(address){
        return lutFunders[index];
    }

    function getAllFunders() external view returns(address[] memory){
        address[] memory _funders = new address[](numOfIndex);

        for(uint256 i = 0; i < numOfIndex;  i++){
            _funders[i] = lutFunders[i];
        }

        return _funders; 
    }

    // Rút tiền
    function withdraw(uint256 withdrawAmount) external{
        payable(msg.sender).transfer(withdrawAmount);
    }

    modifier limitWithdraw(uint withdrawAmount){
        require(withdrawAmount <= 1 * (10**18), "Can't withdraw");
        _;
    }

}