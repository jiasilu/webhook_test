require 'spec_helper'

describe Api::EmailsController do
  describe "#track" do
    before do
      @user = User.new
      @messageThread = MessageThread.new
    end
    context "when there is only one open event in the request" do
      before do
        params = {
          _json: {
            'category' => 'messages',
            'event' => 'open',
            'thread_id' => 1,
            'email' => 'user@example.com'
          }
        }
        User.should_receive(:find_by_email).and_return(@user)
        MessageThread.stub(:find).and_return(@messageThread)
        @messageThread.should_receive(:mark_as_read).with(@user)
        post :track, params
      end

      it "should update the message thread accordingly and return 200" do
        response.status.should == 200
      end
    end

    context "when there are multiple open events in then request" do
      before do
        @messageThread2 = MessageThread.new
        @landlord = Landlord.new
        params = {
          _json: [
            {
              'category' => 'messages',
              'event' => 'open',
              'thread_id' => 1,
              'email' => 'user@example.com'
            },
            {
              'category' => 'messages',
              'event' => 'open',
              'thread_id' => 2,
              'email' => 'user+2@example.com'
            }
          ]
        }
        User.should_receive(:find_by_email).and_return(@user, nil)
        Landlord.should_receive(:find_by_email).and_return(@landlord)
        MessageThread.stub(:find).and_return(@messageThread, @messageThread2)
        @messageThread.should_receive(:mark_as_read).and_return(true)
        post :track, params
      end

      it "should update the message thread accordingly and return 200" do
        response.status.should == 200
      end
    end
  end
end
