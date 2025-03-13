class RideRequest < ApplicationRecord
    # This defines a model named RideRequest that inherits from ApplicationRecord.
    # It represents a database table (likely named "ride_requests").
  
    # Validations
    validates :user_name, presence: true  
    # Ensures that the 'user_name' field must be present (not null or empty).
    
    validates :status, presence: true, inclusion: { in: %w[waiting accepted completed cancelled] }  
    # Ensures that the 'status' field must be present and must be one of the specified values.
  
    # enum status: { waiting: 'waiting', accepted: 'accepted', completed: 'completed', cancelled: 'cancelled' }
    # This line is commented out. If enabled, it would define an enum for 'status',
    # allowing easy querying like `ride_request.waiting?` or `RideRequest.accepted`.
  
    scope :waiting, -> { where(status: 'waiting') }
    # Defines a scope named 'waiting' that filters RideRequests with status 'waiting'.
    # It allows queries like `RideRequest.waiting` to fetch all waiting ride requests.
  
end
