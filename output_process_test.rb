require 'test_helper'

class RideRequestsControllerTest < ActionDispatch::IntegrationTest
  # Create a ride request to use in the tests
  setup do
    @ride_request = RideRequest.create(user_name: "John Doe", status: "waiting")
    # Create a few more requests to test the queue system
    3.times do |i|
      RideRequest.create(user_name: "User #{i + 2}", status: "waiting")
    end
  end

  test "should show estimated wait time and arrival time" do
    # Make a GET request to the show action with the ride request ID
    get ride_request_url(@ride_request)

    # Parse the JSON response
    json_response = JSON.parse(response.body)

    # Calculate expected values
    position = RideRequest.where(status: 'waiting').order(:created_at).pluck(:id).index(@ride_request.id)
    expected_wait_time = position * 5 * 2  # 5 minutes per ride, multiplied by a buffer (2x for round trip)
    expected_arrival_time = (Time.current + expected_wait_time.minutes).strftime('%I:%M %p')

    # Assert the response is successful
    assert_response :success

    # Assert the JSON response contains the correct values
    assert_equal json_response['user'], @ride_request.user_name
    assert_equal json_response['estimated_wait_time'], "#{expected_wait_time} minutes"
    assert_equal json_response['estimated_arrival_time'], expected_arrival_time
  end
end
