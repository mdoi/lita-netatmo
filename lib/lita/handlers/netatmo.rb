module Lita
  module Handlers
    class Netatmo < Handler
      config :client_id,     type: String, required: true
      config :client_secret, type: String, required: true
      config :username,      type: String, required: true
      config :password,      type: String, required: true

      route /^(netatmo|air|空気)/, :air, command: false, help: { "netatmo|air|空気" => "Fetch sensor data from netatmo." }
      def air(response)
        response.reply build_message(stations_data)
      end

      private

      def build_message(data)
        device = data['body']['devices'].first
        inside  = device['dashboard_data']
        outside = device['modules'].first['dashboard_data']

        "[room] #{inside['Temperature']} ℃, #{inside['Humidity']} %, #{inside['Pressure']} hPa, CO2: #{inside['CO2']} ppm\n" +
        "[outside] #{outside['Temperature']} ℃, #{outside['Humidity']} %"
      end

      # https://dev.netatmo.com/doc/methods/getstationsdata
      def stations_data
        require "pry"; binding.pry
        response = http.get 'https://api.netatmo.com/api/getstationsdata', access_token: access_token
        MultiJson.load(response.body)
      end

      def access_token
        token = redis.get 'access_token'
        return token if token

        # https://dev.netatmo.com/doc/authentication/usercred
        response = http.post('https://api.netatmo.com/oauth2/token',
                             grant_type:    'password',
                             client_id:     config.client_id,
                             client_secret: config.client_secret,
                             username:      config.username,
                             password:      config.password,
                             scope:          'read_station')
        auth = MultiJson.load(response.body)
        token = auth['access_token']
        redis.setex 'access_token', (auth['expires_in'] - 10), token
        token
      end

      Lita.register_handler(self)
    end
  end
end
