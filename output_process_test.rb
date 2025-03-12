require 'test_helper'

class RideRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Create multiple ride requests for testing
    @ride_request_1 = RideRequest.create(user_name: 'John Doe', status: 'waiting')
    @ride_request_2 = RideRequest.create(user_name: 'Jane Smith', status: 'waiting')
    @ride_request_3 = RideRequest.create(user_name: 'James Bond', status: 'waiting')
    @ride_request_4 = RideRequest.create(user_name: 'Mary Jane', status: 'waiting')
  end

  test "should show ride request with estimated wait time and arrival time" do
    # Test for the first ride request in the queue
    get ride_request_path(@ride_request_1)

    assert_response :success
    assert_includes @response.body, "User: John Doe"
    assert_includes @response.body, "Estimated wait time:"
    assert_includes @response.body, "Estimated arrival time:"
  end

  test "should show estimated wait time and arrival time for second request in queue" do
    # Test for the second ride request in the queue
    get ride_request_path(@ride_request_2)

    assert_response :success
    assert_includes @response.body, "User: Jane Smith"
    assert_includes @response.body, "Estimated wait time:"
    assert_includes @response.body, "Estimated arrival time:"
  end

  test "should show estimated wait time for third request in queue" do
    # Test for the third ride request in the queue
    get ride_request_path(@ride_request_3)

    assert_response :success
    assert_includes @response.body, "User: James Bond"
    assert_includes @response.body, "Estimated wait time:"
    assert_includes @response.body, "Estimated arrival time:"
  end

  test "should show estimated wait time for fourth request in queue" do
    # Test for the fourth ride request in the queue
    get ride_request_path(@ride_request_4)

    assert_response :success
    assert_includes @response.body, "User: Mary Jane"
    assert_includes @response.body, "Estimated wait time:"
    assert_includes @response.body, "Estimated arrival time:"
  end

  test "should handle ride request not found" do
    # Ensure the error message is returned when the ride request is not found
    get ride_request_path(id: 'nonexistent_id') # Passing a non-existent ID to trigger the error

    assert_response :not_found
    assert_includes @response.body, "Error: Ride request not found."
  end

  test "should show correct estimated wait time with no ride requests in queue" do
    # Test for the scenario where there are no ride requests in the queue
    RideRequest.delete_all # Empty the queue
    new_ride_request = RideRequest.create(user_name: 'Bruce Wayne', status: 'waiting')

    # Ensure the new request is first in the queue and has a wait time of 0
    get ride_request_path(new_ride_request)

    assert_response :success
    assert_includes @response.body, "User: Bruce Wayne"
    assert_includes @response.body, "Estimated wait time: 0 minutes"
  end

  test "should calculate wait time based on position in the queue" do
    # Scenario with multiple ride requests in the queue
    get ride_request_path(@ride_request_1)
    assert_response :success
    assert_includes @response.body, "User: John Doe"
    assert_includes @response.body, "Estimated wait time: 0 minutes"

    get ride_request_path(@ride_request_2)
    assert_response :success
    assert_includes @response.body, "User: Jane Smith"
    assert_includes @response.body, "Estimated wait time: 10 minutes"

    get ride_request_path(@ride_request_3)
    assert_response :success
    assert_includes @response.body, "User: James Bond"
    assert_includes @response.body, "Estimated wait time: 20 minutes"

    get ride_request_path(@ride_request_4)
    assert_response :success
    assert_includes @response.body, "User: Mary Jane"
    assert_includes @response.body, "Estimated wait time: 30 minutes"
  end
end
