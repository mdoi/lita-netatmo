# lita-netatmo

A Lita handler for fetching sensor data from netatmo.

## Installation

Add lita-netatmo to your Lita instance's Gemfile:

``` ruby
gem "lita-netatmo"
```

## Configuration

```ruby
Lita.configure do |config|
  # https://dev.netatmo.com/dev/createapp
  config.handlers.netatmo.client_id = 'xxx'
  config.handlers.netatmo.client_secret = 'xxx'
  config.handlers.netatmo.username = 'xxx' # Your Email
  config.handlers.netatmo.password = 'xxx'
end
```

## Usage

```text
Lita: netatmo
Lita: air
Lita: 空気
```
