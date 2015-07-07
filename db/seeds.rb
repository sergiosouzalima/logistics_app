# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the
#
# rake db:seed (or created alongside the db with db:setup).
#

puts "####### deleting all routes"
Route.delete_all

puts "####### deleting all maps"
Map.delete_all

puts "####### creating map 1"
Map.create( name: "SP" )

puts "####### creating route 1"
Route.create( origin_point: 'A', destination_point: 'B', distance: 10, map_id: 1 )

puts "####### creating route 2"
Route.create( origin_point: 'B', destination_point: 'D', distance: 15, map_id: 1 )

puts "####### creating route 3"
Route.create( origin_point: 'A', destination_point: 'C', distance: 20, map_id: 1 )

puts "####### creating route 4"
Route.create( origin_point: 'C', destination_point: 'D', distance: 30, map_id: 1 )

puts "####### creating route 5"
Route.create( origin_point: 'B', destination_point: 'E', distance: 50, map_id: 1 )

puts "####### creating route 6"
Route.create( origin_point: 'D', destination_point: 'E', distance: 30, map_id: 1 )

