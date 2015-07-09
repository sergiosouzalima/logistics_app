# encoding : utf-8
require 'rails_helper'

RSpec.describe Api::V1::BaseController, :type => :controller do

  context "#create_map_routes" do
    context "when invalid parameters" do
      describe "and no parameters are present" do
        before do
          @result = Api::V1::BaseController.create_map_routes( nil, nil )
        end
        it "returns a String" do
          expect(@result).to be_an_instance_of(String)
        end
        it "returns an error message" do
          expect(@result).to eql "invalid parameter"
        end
      end
      describe "and routes is an empty array" do
        before do
          @result = Api::V1::BaseController.create_map_routes( "SP", [] )
        end
        it "returns a String" do
          expect(@result).to be_an_instance_of(String)
        end
        it "returns an error message" do
          expect(@result).to eql "invalid parameter. 'Routes' is empty"
        end
      end
      describe "and routes does not have a 3 elements hash" do
        before do
          @result = Api::V1::BaseController.create_map_routes( "SP",
                                                              [{"origin":"A","destination":"B","distance":10},
                                                               {"origin":"A","destination":"C"},
                                                               {"origin":"A","destination":"D","distance":25}]
                                                             )
        end
        it "returns a String" do
          expect(@result).to be_an_instance_of(String)
        end
        it "returns an error message" do
          expect(@result).to eql "invalid parameter. 'Routes' must be a 3 elements hash"
        end
      end
      describe "and routes does not have a 3 elements hash with value" do
        before do
          @result = Api::V1::BaseController.create_map_routes( "SP",
                                                              [{"origin":"A","destination":"B","distance":10},
                                                               {"origin":"A","destination":"","distance":20}]
                                                             )
        end
        it "returns a String" do
          expect(@result).to be_an_instance_of(String)
        end
        it "returns an error message" do
          expect(@result).to eql "invalid parameter. All elements in 'Routes' must have a value"
        end
      end
    end
    context "when valid parameters" do
      describe "and Map doesn't exist" do
        before do
          @map_name = "MS"
          routes = [{"distance": 10, "origin": "A", "destination": "B"},
                    {"distance": 15, "origin": "B", "destination": "D"}]
          @result = Api::V1::BaseController.create_map_routes( @map_name, routes )
        end
        it "returns a String" do
          expect(@result).to be_an_instance_of(String)
        end
        it "returns a successfully creating message" do
          expect(@result).to eql "Map and routes created successfully"
        end
        it "returns the Map name correctly" do
          map = Map.find_by( name: @map_name )
          expect(map[:name]).to eql @map_name
        end
        it "returns all routes correctly" do
          routes      = [{"distance": 10, "origin": "A", "destination": "B"},
                         {"distance": 15, "origin": "B", "destination": "D"}]
          map_id      = Map.find_by( name: "MS" ).id
          rec_counter = 0
          routes.each do |key|
            qty = Route.where( distance: key[:distance], origin_point: key[:origin],
                              destination_point: key[:destination], map_id: map_id ).count
            rec_counter += 1
          end
          expect(rec_counter).to eql routes.size
        end
      end
      describe "and Map already exists" do
        before do
          @map_name = "MS"
          routes = [{"distance": 10, "origin": "A", "destination": "B"},
                    {"distance": 15, "origin": "B", "destination": "D"}]
          @result = Api::V1::BaseController.create_map_routes( @map_name, routes )
        end
        it "returns a String" do
          expect(@result).to be_an_instance_of(String)
        end
        it "returns a successfully creating message" do
          expect(@result).to eql "Map and routes created successfully"
        end
        it "returns only one Map" do
          map_qty = Map.where( name: @map_name ).count
          expect(map_qty).to eql 1
        end
        it "returns the Map name correctly" do
          map = Map.find_by( name: @map_name )
          expect(map[:name]).to eql @map_name
        end
        it "returns all routes correctly" do
          routes      = [{"distance": 10, "origin": "A", "destination": "B"},
                         {"distance": 15, "origin": "B", "destination": "D"}]
          map_id      = Map.find_by( name: "MS" ).id
          rec_counter = 0
          routes.each do |key|
            qty = Route.where( distance: key[:distance], origin_point: key[:origin],
                              destination_point: key[:destination], map_id: map_id ).count
            rec_counter += 1
          end
          expect(rec_counter).to eql routes.size
        end
      end
    end
  end

  context "#find_the_cheapest_route" do
    context "when valid parameters" do
      describe "and a route is found" do
        before do
          FactoryGirl.create(:map)
          FactoryGirl.create(:route)
          @result = Api::V1::BaseController.find_the_cheapest_route( 'SP', 'A', 'B', 10, 2.5 )
        end
        it "returns a Hash" do
          expect(@result).to be_an_instance_of(Hash)
        end
        it "returns a hash with valid elements" do
          expect(@result[:distance]).to eql 10
          expect(@result[:cost]).to eql 2.5
          expect(@result[:directions]).to eql ['A','B']
        end
      end
    end
    context "when invalid parameters" do
      describe "and no parameters are present" do
        before do
          @result = Api::V1::BaseController.find_the_cheapest_route( nil, nil, nil, nil, nil )
        end
        it "returns a String" do
          expect(@result).to be_an_instance_of(String)
        end
        it "returns an error message" do
          expect(@result).to eql "invalid parameter"
        end
      end
      describe "and fuel_autonomy is zero and other parameters are present" do
        before do
          @result = Api::V1::BaseController.find_the_cheapest_route( "SP", "A", "B", 0, 2.5 )
        end
        it "returns a String" do
          expect(@result).to be_an_instance_of(String)
        end
        it "returns an error message" do
          expect(@result).to eql "invalid parameter. fuel_autonomy is 0"
        end
      end
      describe "and Map was not found" do
        before do
          @result = Api::V1::BaseController.find_the_cheapest_route( 'XX', 'A', 'D', 10, 2.5 )
        end
        it "returns a String" do
          expect(@result).to be_an_instance_of(String)
        end
        it "returns an error message" do
          expect(@result).to eql "map_name not found"
        end
      end
      describe "and Origin Route was not found" do
        before do
          FactoryGirl.create(:map)
          FactoryGirl.create(:route)
          @result = Api::V1::BaseController.find_the_cheapest_route( 'SP', 'X', 'D', 10, 2.5 )
        end
        it "returns a String" do
          expect(@result).to be_an_instance_of(String)
        end
        it "returns an error message" do
          expect(@result).to eql "origin route not found"
        end
      end
    end
  end

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
          @error = "map_name not found"
          @result = Api::V1::BaseController.error_message( nil, @error )
        end
        it "returns a hash" do
          expect(@result).to be_an_instance_of(Hash)
        end
        it "returns a hash with error elements" do
          expect(@result[:status]).to eql 'ERROR'
          expect(@result[:code]).to eql 'TOO_FEW_PARAMETERS'
          expect(@result[:fallback_msg]).to eql @error
        end
      end
    end
    context "when valid parameters" do
      describe "both parameters are present" do
        before do
          @error = "origin route not found"
          @result = Api::V1::BaseController.error_message( {name: "SP"}, @error )
        end
        it "returns a hash" do
          expect(@result).to be_an_instance_of(Hash)
        end
        it "returns a hash with valid elements" do
          expect(@result[:status]).to eql 'ERROR'
          expect(@result[:code]).to eql 'WRONG_DATA'
          expect(@result[:name]).to eql 'SP'
          expect(@result[:fallback_msg]).to eql @error
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

