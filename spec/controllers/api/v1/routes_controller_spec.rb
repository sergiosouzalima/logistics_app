# encoding : utf-8
require 'rails_helper'

RSpec.describe Api::V1::RoutesController, :type => :controller do

  context "when valid parameters" do
    describe "GET #get_route" do
      before do
        param = {map_name:'SP',origin:'A',destination:'B',fuel_autonomy:10,fuel_price:2.5,format:'json'}
        FactoryGirl.create(:map)
        FactoryGirl.create(:route)
        get :get_route, param
        @result = JSON.parse(response.body, symbolize_names: true)
      end
      it "returns success code" do
        # test for the 200 status-code
        expect(response).to be_success
      end
      it "returns a correct distance" do
        expect(@result[:fallback_msg][:distance]).to eql 10
      end
      it "returns a correct cost" do
        expect(@result[:fallback_msg][:cost]).to eql 2.5
      end
      it "returns correct directions" do
        expect(@result[:fallback_msg][:directions]).to eql ['A','B']
      end
    end
  end

end

