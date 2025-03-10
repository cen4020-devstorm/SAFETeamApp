# Ride Requests Controller README

This file provides an overview of the `RideRequestsController` class in a Ruby on Rails application, which is part of an app designed to address the issue faced by students at USF when requesting rides from the SAFE Team.

---

## Table of Contents

- [Overview](#overview)
- [Controller Actions](#controller-actions)
  - [show](#show)
- [Private Methods](#private-methods)
  - [set_ride_request](#set_ride_request)
  - [calculate_estimated_wait_time](#calculate_estimated_wait_time)
  - [calculate_estimated_arrival_time](#calculate_estimated_arrival_time)
- [Dependencies](#dependencies)
- [Future Improvements](#future-improvements)

---

## Overview

The `RideRequestsController` class is part of the application responsible for calculating and providing estimated wait times and arrival times for students requesting rides from the SAFE Team. 

### Key Features:
- **Estimated Wait Time:** Calculates how long a student will have to wait for their ride based on the position in the queue.
- **Estimated Arrival Time:** Provides an estimated arrival time by adding the calculated wait time to the current system time.

---

## Controller Actions

### show

- **Path:** `/ride_requests/:id`
- **HTTP Method:** `GET`
- **Description:** This action retrieves the estimated wait time and arrival time for a specific ride request, allowing students to know when their ride is expected to arrive.
  
#### Process:
1. **Retrieve the Queue of Waiting Requests:** The controller fetches all ride requests with the status `waiting`, ordered by their creation time.
2. **Determine Position in Queue:** The current ride request's position in the waiting list is calculated.
3. **Calculate Estimated Wait Time:** Based on the student's position in the queue, the wait time is estimated.
4. **Calculate Estimated Arrival Time:** The arrival time is computed by adding the wait time to the current system time.
5. **Return JSON Response:** A JSON response is returned with the user's name, estimated wait time, and estimated arrival time.

#### JSON Response Example:
```json
{
  "user": "John Doe",
  "estimated_wait_time": "10 minutes",
  "estimated_arrival_time": "02:30 PM"
}
```

---

## Private Methods

### set_ride_request

```ruby
def set_ride_request
  @ride_request = RideRequest.find(params[:id])
end
```

- **Purpose:** Sets the `@ride_request` instance variable using the `id` parameter in the request. It is called before executing the `show` action to ensure the correct ride request is being processed.
  
- **Usage:** Fetches the ride request from the database based on the given `id` parameter.

### calculate_estimated_wait_time

```ruby
def calculate_estimated_wait_time(requests_in_queue, position)
  avg_ride_time = 5 # Assuming each ride takes 5 minutes
  requests_in_queue[0..position-1].count * avg_ride_time * 2
end
```

- **Purpose:** Calculates the estimated wait time for a student based on their position in the queue.
  
- **Arguments:**
  - `requests_in_queue`: A collection of waiting ride requests.
  - `position`: The student's position in the queue.
  
- **Logic:** The method multiplies the number of requests ahead of the current one by the average ride time (5 minutes), assuming a round-trip factor of 2 (for the pick-up and drop-off). This gives the total estimated wait time in minutes.

### calculate_estimated_arrival_time

```ruby
def calculate_estimated_arrival_time(estimated_wait_time)
  Time.current + estimated_wait_time.minutes
end
```

- **Purpose:** Calculates the estimated arrival time by adding the estimated wait time to the current system time.
  
- **Arguments:**
  - `estimated_wait_time`: The estimated number of minutes the student will have to wait for their ride.
  
- **Logic:** The method adds the estimated wait time to the current time (`Time.current`) to compute the estimated arrival time of the student's ride.

---

## Dependencies

- **Rails Version:** The application is built using Ruby on Rails.
  
