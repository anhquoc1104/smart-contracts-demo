/* *
 * Minter: Người khởi tạo
 * Suply: Lượng cung (không vượt quá bao nhiêu)
 * Balance: Số dư ví 
 * Sent Token: 
        Receiver: Người nhận
            Amount: Khối lượng chuyển (<= Balance)
            Balance sender -= amount
            Balance receiver += amount
 * Variable :
    bool
    uint
    int
    string
    address
 * 
 *
 *  
 *  */

pragma solidity >=0.7.4 <0.9.0;

contract Faucet {
    /* Variable */
    address public minter; // Địa chỉ người khởi tạo
    mapping(address => uint256) public balances; // mapping: ánh xạ kiểu address về uint
    // Khai báo sự kiện
    event sent(address from, address to, uint256 amount);

    // modifier: Dùng để khai báo khởi tạo cho các hàm sử dụng (kế thừa)
    modifier onlyMinter {
        require(msg.sender == minter); // require: điều kiện thỏa mãn mới thực thi fn
        _; // Chỉ chạy nội dung bên trên khi fn được gọi (khác constructor)
    }

    modifier checkAmount(uint amount){
        require(amount < 1e60);
        _;
    }
    modifier checkBalance(uint amount){
        require(amount <= balances[msg.sender], "Not enough balance");
        _;
    }

    uint256 public countPlayer = 0;
    mapping(address => Player) public players;
    enum Level {
        Beginer,
        Intermediate,
        Advance
    }
    // Kiểu struct
    struct Player {
        address addressPlayer;
        Level myLevel;
        string fullname;
        uint256 age;
        string sex;
        uint createdTime;
    }

    // add kiểu dữ liệu vào struct Player
    function addPlayer( string memory fullname, uint256 age, string memory sex ) public {
        // memory: cách lưu trữ
        players[msg.sender] = Player(msg.sender, Level.Beginer, fullname, age, sex, block.timestamp); // players mapping sẽ nhận index là address. Khi truy vấn chỉ cần truyền address vào sẽ được mapping ra Player
        countPlayer += 1;
    }
    // fn phân cấp Level
    function getPlayerLevel(address addressPlayer) public returns (Level){ // returns: có thể trả về nhiều giá trị
        return players[addressPlayer].myLevel;
    }

    function changePlayerLevel(address playerAddress) public {
        Player storage player = players[playerAddress];
        if(block.timestamp >= player.createdTime + 15){
            player.myLevel = Level.Intermediate;
        }
    }

    constructor() {
        minter = msg.sender; // Người gởi tiền đi.
    }

    // fn khởi tạo 1 lượng token ban đầu
    function mint(address receiver, uint256 amount) public onlyMinter checkAmount(amount) {
        // require(msg.sender == minter); // require: điều kiện thỏa mãn mới thực thi fn
        // require(amount < 1e60);
        balances[receiver] += amount;
    }

    // fn chuyển tiền
    function send(address receiver, uint256 amount) public checkBalance(amount) {
        // require(amount <= balances[msg.sender], "Not enough balance");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit sent(msg.sender, receiver, amount);
    }
}
