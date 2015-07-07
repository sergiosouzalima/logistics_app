# encoding : utf-8
require 'rails_helper'

RSpec.describe Map, type: :model do

  context "attributes validation" do
    context 'name' do
      it { should respond_to :name }
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name) }
    end
  end

  context "content validation" do
    context 'name' do
      it "has a valid content" do
        map = FactoryGirl.create(:map)
        expect(map.name).to eql "Sao Paulo"
      end
      it "is invalid without a name" do
        expect( FactoryGirl.build(:map, name: nil) ).not_to be_valid
      end
      it "can't be duplicate" do
        new_map = FactoryGirl.create(:map)
        expect( FactoryGirl.build(:map, name: new_map.name) ).not_to be_valid
      end
    end
  end

  context "relationships" do
    before do
      r1 = FactoryGirl.create(:route, origin_point: "A", destination_point: "B", distance: 10)
      r2 = FactoryGirl.create(:route, origin_point: "B", destination_point: "D", distance: 15)
      r3 = FactoryGirl.create(:route, origin_point: "A", destination_point: "C", distance: 20)
      @map = FactoryGirl.create(:map, routes: [r1, r2, r3])
    end

    it "A Map has many routes" do
      expect(@map.routes.count).to eq 3
      expect(@map.routes.map(&:distance)).to include 10, 15, 20
      expect(@map.routes.map(&:origin_point)).to include "A", "B", "A"
      expect(@map.routes.map(&:destination_point)).to include "B", "D", "C"
    end
  end

end

