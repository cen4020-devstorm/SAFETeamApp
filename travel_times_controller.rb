# class TravelTimesController < ApplicationController
#     def new
#     end
  
#     def create
#       origin = params[:origin]
#       destination = "4103 USF Cedar Cir, Tampa, FL 33620" # Fixed destination
  
#       result = TravelTimeService.get_travel_time(origin, destination)
  
#       if result[:error]
#         flash[:alert] = result[:error]
#         render :new
#       else
#         @duration = result[:duration]
#         @distance = result[:distance]
#         render :show
#       end
#     end
#   end

class TravelTimesController < ApplicationController
    def new
    end
  
    def create
      origin = params[:origin]
      destination = "4103 USF Cedar Cir, Tampa, FL 33620"
  
      result = TravelTimeService.get_travel_time(origin, destination)
  
      if result[:error]
        flash[:alert] = result[:error]
        render :new
      else
        @duration = result[:duration]
        @distance = result[:distance]
        render :show
      end
    end
  end
  
  
  