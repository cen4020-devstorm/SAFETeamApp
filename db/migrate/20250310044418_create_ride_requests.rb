class CreateRideRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :ride_requests do |t|
      t.integer :ride_request_number

      t.timestamps
    end
  end
end
