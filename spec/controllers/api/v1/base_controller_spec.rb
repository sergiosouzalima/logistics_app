# encoding : utf-8
require 'rails_helper'

RSpec.describe Api::V1::BaseController, :type => :controller do

  context "#error_message" do
    context "when invalid parameters" do
      describe "and no parameters are present" do
        before do
          @result = Api::V1::BaseController.error_message( nil, nil )
        end
        it "returns a hash" do
          expect(@result).to be_an_instance_of(Hash)
        end
        it "returns an empty hash" do
          expect(@result).to be_empty
        end
      end
      describe "and api_parameter is present and object is nil" do
        before do
          @result = Api::V1::BaseController.error_message( {name: "SP"}, nil )
        end
        it "returns a hash" do
          expect(@result).to be_an_instance_of(Hash)
        end
        it "returns a hash with error elements" do
          expect(@result[:status]).to eql 'ERROR'
          expect(@result[:code]).to eql 'TOO_FEW_PARAMETERS'
          expect(@result[:fallback_msg]).to eql 'EMPTY OBJECT PARAMETER'
        end
      end
      describe "and object is present and api_parameter is nil" do
        before do
          @error_object = ActiveRecord::RecordNotFound.new
          @result = Api::V1::BaseController.error_message( nil, @error_object )
        end
        it "returns a hash" do
          expect(@result).to be_an_instance_of(Hash)
        end
        it "returns a hash with error elements" do
          expect(@result[:status]).to eql 'ERROR'
          expect(@result[:code]).to eql 'TOO_FEW_PARAMETERS'
          expect(@result[:fallback_msg]).to eql @error_object.message
        end
      end
    end
    context "when valid parameters" do
      describe "both parameters are present" do
        before do
          @error_object = ActiveRecord::RecordNotFound.new
          @result = Api::V1::BaseController.error_message( {name: "SP"}, @error_object )
        end
        it "returns a hash" do
          expect(@result).to be_an_instance_of(Hash)
        end
        it "returns a hash with valid elements" do
          expect(@result[:status]).to eql 'ERROR'
          expect(@result[:code]).to eql 'WRONG_DATA'
          expect(@result[:name]).to eql 'SP'
          expect(@result[:fallback_msg]).to eql @error_object.message
        end
      end
    end
  end

  context "#success_message" do
    context "when invalid parameters" do
      describe "and no parameters are present" do
        before do
          @result = Api::V1::BaseController.success_message( nil, nil )
        end
        it "returns a hash" do
          expect(@result).to be_an_instance_of(Hash)
        end
        it "returns an empty hash" do
          expect(@result).to be_empty
        end
      end
      describe "and api_parameter is present and message is nil" do
        before do
          @result = Api::V1::BaseController.success_message( {name: "SP"}, nil )
        end
        it "returns a hash" do
          expect(@result).to be_an_instance_of(Hash)
        end
        it "returns a hash with an error fallback_msg" do
          expect(@result[:status]).to eql 'OK'
          expect(@result[:code]).to eql 'OK'
          expect(@result[:fallback_msg]).to eql 'EMPTY MESSAGE PARAMETER'
        end
      end
      describe "and message is present and api_parameter is nil" do
        before do
          @message = { "distance": 25, "cost": 6.25, "directions": [ "A", "B", "D" ] }
          @result = Api::V1::BaseController.success_message( nil, @message )
        end
        it "returns a hash" do
          expect(@result).to be_an_instance_of(Hash)
        end
        it "returns a hash with success elements" do
          expect(@result[:status]).to eql 'OK'
          expect(@result[:code]).to eql 'OK'
          expect(@result[:fallback_msg]).to eql @message
        end
      end
    end
    context "when valid parameters" do
      describe "both parameters are present" do
        before do
          @message = { "distance": 25, "cost": 6.25, "directions": [ "A", "B", "D" ] }
          @result = Api::V1::BaseController.success_message( {name: "SP"}, @message )
        end
        it "returns a hash" do
          expect(@result).to be_an_instance_of(Hash)
        end
        it "returns a hash with valid elements" do
          expect(@result[:status]).to eql 'OK'
          expect(@result[:code]).to eql 'OK'
          expect(@result[:name]).to eql 'SP'
          expect(@result[:fallback_msg]).to eql @message
        end
      end
    end
  end

end

