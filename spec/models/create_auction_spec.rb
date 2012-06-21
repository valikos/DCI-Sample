require 'model_spec_helper'

describe CreateAuction do
  let(:seller){User.new}
  let(:params){
    AuctionParams.new(item_name: "Item", item_description: "Description", buy_it_now_price: 10)
  }
  let(:expected_item){double("Item")}
  let(:expected_auction){double("Auction", :start => nil)}

  context "successful creation" do
    before :each do
      Item.should_receive(:make).with("Item", "Description").and_return(expected_item)
      Auction.should_receive(:make).with(seller, expected_item, 10).and_return(expected_auction)
    end

    it "should create an auction" do
      actual_auction = create_auction[:auction]
      actual_auction.should == expected_auction
    end

    it "should start the created auction" do
      expected_auction.should_receive(:start)
      create_auction
    end
  end

  context "error handling" do
    it "should return errors when cannot create an item" do
      Item.should_receive(:make).and_raise(InvalidRecordException.new(%w{error1}))
      create_auction[:errors].should be_present
    end

    it "should return errors when cannot create an auction" do
      Item.should_receive(:make).with("Item", "Description").and_return(expected_item)
      Auction.should_receive(:make).and_raise(InvalidRecordException.new(%w{error1}))
      create_auction[:errors].should be_present
    end
  end

  private

  def create_auction
    CreateAuction.new(seller, params).create
  end
end
