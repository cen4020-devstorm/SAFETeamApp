
require "test_helper"

class RideRequestsController < ApplicationController
  before_action :set_ride_request, only: [:show]

  # Show estimated wait time and arrival time
  def show
    if @ride_request.nil?
      return
    end

    # Retrieve all ride requests that are waiting, ordered by creation time
    requests_in_queue = RideRequest.where(status: 'waiting').order(:created_at)
    
    # Determine the position of the current ride request in the queue
    position = requests_in_queue.pluck(:id).index(@ride_request.id)
    
    # Calculate the estimated wait time based on queue position
    estimated_wait_time = calculate_estimated_wait_time(requests_in_queue, position)
    
    # Calculate the estimated arrival time by adding wait time to the current time
    estimated_arrival_time = calculate_estimated_arrival_time(estimated_wait_time)

    # Print output to the terminal (or logs)
    puts "Showing ride request details:"
    puts "User: #{@ride_request.user_name}"
    puts "Estimated wait time: #{estimated_wait_time} minutes"
    puts "Estimated arrival time: #{estimated_arrival_time.strftime('%I:%M %p')}"
  end

  private

  # Set the ride request using the provided ID from the parameters
  def set_ride_request
    @ride_request = RideRequest.find_by(id: params[:id])
  end

  # Calculate the estimated wait time based on the queue
  def calculate_estimated_wait_time(requests_in_queue, position)
    avg_ride_time = 5 # Assuming each ride takes 5 minutes
    requests_in_queue[0..position-1].count * avg_ride_time * 2
  end

  # Calculate the estimated arrival time based on wait time
  def calculate_estimated_arrival_time(estimated_wait_time)
    Time.current + estimated_wait_time.minutes # Add estimated wait time to the current time
  end
end



