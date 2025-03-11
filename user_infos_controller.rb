# class UserInfosController < ApplicationController
#     def new
#       @user_info = UserInfo.new
#     end
  
#     def create
#       @user_info = UserInfo.new(user_info_params)
#       if @user_info.save
#         redirect_to @user_info, notice: "Information saved successfully!"
#       else
#         flash.now[:alert] = "There was an error with your input."
#         render :new
#       end
#     end
  
#     def show
#       @user_info = UserInfo.find(params[:id])
#     end
  
#     private
  
#     def user_info_params
#       params.require(:user_info).permit(:name, :phone, :location, :destination)
#     end
#   end

class UserInfosController < ApplicationController
    def new
      @user_info = UserInfo.new
    end
  
    def create
      @user_info = UserInfo.new(user_info_params)
  
      if @user_info.valid?
        driver_location = "4103 USF Cedar Cir, Tampa, FL 33620" # Driver starts here
        pickup_location = @user_info.location

        pickup_coords = TravelTimeService.get_coordinates(pickup_location)

        if pickup_coords[:error]
            flash[:alert] = "Invalid pickup location: #{pickup_coords[:error]}"
            render :new, status: :unprocessable_entity
            return
        end
  
        # Get the estimated waiting time (driver to user)
        wait_time_result = TravelTimeService.get_travel_time(driver_location, pickup_location)
  
        if wait_time_result[:error]
          flash[:alert] = wait_time_result[:error]
          render :new, status: :unprocessable_entity
        else
          @user_info.save
          @waiting_time = wait_time_result[:duration]
          @waiting_distance = wait_time_result[:distance]
          render :show
        end
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    private
  
    def user_info_params
      params.require(:user_info).permit(:name, :phone, :location, :destination)
    end
  end
  
  