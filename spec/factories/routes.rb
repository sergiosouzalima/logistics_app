FactoryGirl.define do
  factory :route do
    origin_point "A"
    destination_point "B"
    distance 10
    map nil
  end
end
