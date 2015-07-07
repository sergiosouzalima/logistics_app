# encoding : utf-8
require 'rails_helper'

RSpec.describe Route, type: :model do

  context "attributes validation" do
    context 'origin_point' do
      it { should respond_to :origin_point }
      it { should validate_presence_of(:origin_point) }
    end
    context 'destination_point' do
      it { should respond_to :destination_point }
      it { should validate_presence_of(:destination_point) }
    end
    context 'distance' do
      it { should respond_to :distance }
      it { should validate_presence_of(:distance) }
    end
  end

  context "content validation" do
    before do
      @route = FactoryGirl.create( :route )
    end
    context 'origin_point' do
      it "has a valid content" do
        expect(@route.origin_point).to eql "A"
      end
      it "is invalid without a content" do
        expect( FactoryGirl.build(:route, origin_point: nil) ).not_to be_valid
      end
    end
    context 'destination_point' do
      it "has a valid content" do
        expect(@route.destination_point).to eql "B"
      end
      it "is invalid without a content" do
        expect( FactoryGirl.build(:route, destination_point: nil) ).not_to be_valid
      end
    end
    context 'distance' do
      it "has a valid content" do
        expect(@route.distance).to eql 10
      end
      it "is invalid without a content" do
        expect( FactoryGirl.build(:route, distance: nil) ).not_to be_valid
      end
    end
  end

  context "relationships" do
    before do
      @r1 = FactoryGirl.create(:route, origin_point: "A", destination_point: "B", distance: 10)
      @r2 = FactoryGirl.create(:route, origin_point: "B", destination_point: "D", distance: 15)
      @r3 = FactoryGirl.create(:route, origin_point: "A", destination_point: "C", distance: 20)
      FactoryGirl.create(:map, routes: [@r1, @r2, @r3])
    end

    it "A Route belongs to Map" do
      expect(@r1.map_id).to eq 1
      expect(@r2.map_id).to eq 1
      expect(@r3.map_id).to eq 1
    end
  end


end

