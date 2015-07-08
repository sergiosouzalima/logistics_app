# encoding : utf-8
require 'rails_helper'

RSpec.describe Api::V1::RoutesController, :type => :controller do

  context "POST create_map" do
    context "when invalid parameters" do
      describe "and map_name was not found" do
        before do
          routes = [{"distance": 10, "origin": "A", "destination": "B"},
                    {"distance": 15, "origin": "B", "destination": "D"}]
          param = {map_name:'SP', format:'json'}
          post :create_map, param
          @result = JSON.parse(response.body, symbolize_names: true)
        end
        it "returns success code" do
          # test for the 200 status-code
          expect(response).to be_success
        end
      end
    end
  end

  context "GET #get_route" do
    context "when invalid parameters" do
      describe "and map_name was not found" do
        before do
          param = {map_name:'XY',origin:'A',destination:'B',fuel_autonomy:10,fuel_price:2.5,format:'json'}
          FactoryGirl.create(:map)
          FactoryGirl.create(:route)
          get :get_route, param
          @result = JSON.parse(response.body, symbolize_names: true)
        end
        it "returns success code" do
          # test for the 200 status-code
          expect(response).to be_success
        end
        it "returns an error" do
          expect(@result[:fallback_msg]).to eql "map_name not found"
        end
      end
      describe "and origin was not found" do
        before do
          param = {map_name:'SP',origin:'*',destination:'B',fuel_autonomy:10,fuel_price:2.5,format:'json'}
          FactoryGirl.create(:map)
          FactoryGirl.create(:route)
          get :get_route, param
          @result = JSON.parse(response.body, symbolize_names: true)
        end
        it "returns success code" do
          # test for the 200 status-code
          expect(response).to be_success
        end
        it "returns an error" do
          expect(@result[:fallback_msg]).to eql "origin route not found"
        end
      end
      describe "and destination was not found" do
        before do
          param = {map_name:'SP',origin:'A',destination:'*',fuel_autonomy:10,fuel_price:2.5,format:'json'}
          FactoryGirl.create(:map)
          FactoryGirl.create(:route)
          get :get_route, param
          @result = JSON.parse(response.body, symbolize_names: true)
        end
        it "returns success code" do
          # test for the 200 status-code
          expect(response).to be_success
        end
        it "returns an error" do
          expect(@result[:fallback_msg]).to eql "destination route not found"
        end
      end
    end
    context "when valid parameters" do
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

