pragma solidity >=0.7.4 < 0.9.0;

contract Auction {
    /* Variable */
    address payable public beneficiary;
    uint public auctionEndTime;
    uint public highestBid;
    address public highestBidder;
    bool ended = false;

    mapping(address => uint) public pendingReturns; // Gở vào address trả về unit, tên của mapping là pendingReturns

    // Sự kiện thay đổi giá trị đấu giá khi có người đặt cao hơn (thỏa điều kiện)
    event highestBidIncrease(address bidder, uint amount);
    // Sự kiện đánh dấu người chiến thắng
    event auctionEnded(address winner, uint amount);

    // Tạo contructor t.gian kết thúc ()
    constructor (uint _biddingTime, address payable _beneficiary){
        beneficiary = _beneficiary;
        auctionEndTime = block.timestamp + _biddingTime;
    }

    /* Funtion */
    // Đấu giá sản phẩm
    function bid() public payable{ // payable: fn có khả năng thanh toán
        if(block.timestamp > auctionEndTime){ // time tạo khối > time đấu giá
            // revert: trả về 1 giá trị và kết thúc
            revert("Blocked Time");
        }
        if(msg.value <= highestBid){
            revert("Not Enough Money");
        }
        if(highestBid != 0){
            pendingReturns[highestBidder] +=highestBid;
        }

        highestBidder = msg.sender; // sender: người khởi tạo
        highestBid = msg.value; // value: giá trị gởi vào

        // Gọi sự kiện event ở trên
        emit highestBidIncrease(msg.sender, msg.value);
    }

    // Rút lại tiền nếu có người trả giá cao hơn
    function withdraw() public returns(bool){
        uint amount = pendingReturns[msg.sender]; // amount: số tiền sẽ được rút
        if(amount > 0){
            //Sau khi rút tiền thành công, thì set về = 0 để không cho rút nữa
            pendingReturns[msg.sender] = 0;

            // Tạo dữ liệu để gơi tiền về
            if(!payable(msg.sender).send(amount)){ // payable: nếu xác thực thành coogn mới gởi tiền 
                pendingReturns[msg.sender] = amount; // hoàn tiền thất bại, gán lại amount để rút lại
                return false;
            }
        }
    }

    // Xác định thời điểm kết thúc đấu giá
    function auctionEnd() public{
        if(ended){
            revert("ENDED AUCTION");
        }

        if(block.timestamp < auctionEndTime){
            revert("DONT END AUCTION");
        }

        ended = true;
        emit auctionEnded(highestBidder, highestBid);

        // Trả lại giá trị cho người thừa hưởng (người bán đấu giá - owner)
        beneficiary.transfer(highestBid);
    }
}