class LandingController < ApplicationController

  def home
    # ACTUAL LOCATION OF IP GEOLOOKUP - WILL ONLY WORK WHEN DEPOLYED
    @visitor_location = request.location.city

    # HARDCODED LOCATION FOR TESTING
    #@visitor_location = "Phoenix"

    response = HTTParty.get("http://api.apixu.com/v1/search.json?key=#{ENV['apixu_api_key']}&q=#{params[:city]}")
    response2 = HTTParty.get("http://api.apixu.com/v1/history.json?key=#{ENV['apixu_api_key']}&q=#{params[:city]}&dt=#{params[:date]}")

    if params[:city] != "" && params[:city] != nil
      if !response.blank?
        @lookup_location = response[0]['name']
      end
    end

    if params[:date] != "" && params[:date] != nil

      if !response2['error']
        @lookup_date = response2['forecast']['forecastday'][0]['date']
        @rails_json = response2
        @temp = []
        #@humidity = []
        for i in 0..23
          @temp[i] = response2['forecast']['forecastday'][0]['hour'][i]['temp_f']
          #@humidity[i] = response2['forecast']['forecastday'][0]['hour'][i]['humidity']
        end
      else
        render(
              html: "<script>
                    if(confirm('Please check your input.')) {
                      window.location.reload();
                      }
                    else {
                      window.location.reload();
                    }
                    </script>".html_safe,
              layout: 'application'
              )
      end
    end
  end

  def contact
  end

  def about
  end

  def blog
  end

  def iot
    @poll_time = Time.now.in_time_zone("Arizona").strftime("%I:%M:%S %p")



    downstairs_temp_array = HTTParty.get("http://blynk-cloud.com/#{ENV['blynk_downstairs_sensor_key']}/get/V1")
    downstairs_humidity_array = HTTParty.get("http://blynk-cloud.com/#{ENV['blynk_downstairs_sensor_key']}/get/V2")

    @downstairs_temp = downstairs_temp_array[0].to_f.round(2)
    @downstairs_humidity = downstairs_humidity_array[0].to_f.round(1)

    garage_status = HTTParty.get("http://blynk-cloud.com/#{ENV['blynk_garage_door_key']}/get/V1")

    if garage_status[0].to_i == 0
      @garagedoor = "Closed"
    else
      @garagedoor = "Open"
    end

    pool_temp_array = HTTParty.get("http://blynk-cloud.com/#{ENV['blynk_pool_temperature_key']}/get/V1")

    @pool_temperature = pool_temp_array[0]

  end


  def send_contact_email
    ContactMailer.contact_email(params[:name],params[:email],params[:phone],params[:subject],params[:message]).deliver_now
    redirect_to contact_path
  end

end
