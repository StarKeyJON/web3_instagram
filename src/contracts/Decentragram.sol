pragma solidity ^0.5.0;

contract Decentragram {
  // Code goes here...
  string public name = "Decentragram";

  //Store Images
  uint public imageCount = 0;

  //create mapping key value structures
  mapping(uint => Image) public images;

  struct Image {
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }
  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );
    event ImageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  //Create imgs
  function uploadImage(string memory _imgHash, string memory _description) public {
   //make sure the image hash exists
    require(bytes(_imgHash).length > 0);
    //make sure image decription exists
    require(bytes(_description).length > 0);

    //make sure uploader address exists
    require(msg.sender != address(0x0));

   //increment image array length
    imageCount ++;

  //add image to contract
    images[imageCount] = Image(imageCount, _imgHash, _description, 0, msg.sender);
 
  //trigger event
    emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
  }

  //Tip imgs
  function tipImageOwner(uint _id) public payable {
    //make sure id is valid
    require(_id > 0 && _id <= imageCount);
    //find the image
    Image memory _image = images[_id];
    //find the author
    address payable _author = _image.author;
    //transfer them the same value that was sent
    address(_author).transfer(msg.value);
    //increment tip amount
    _image.tipAmount = _image.tipAmount + msg.value;
    //update the image
    images[_id] = _image;
    //trigger an event and emit
    emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);
  }
}