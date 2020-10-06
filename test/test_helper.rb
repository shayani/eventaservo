# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/autorun'

# SimpleCov
require 'simplecov'
SimpleCov.start

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include FactoryBot::Syntax::Methods
  include ActionMailer::TestHelper

  # Geocoder test configuration
  Geocoder.configure(lookup: :test, ip_lookup: :test)
  Geocoder::Lookup::Test.add_stub(
    'Sao Paŭlo, BR', [
      {
        coordinates: [-23.55, -46.63],
        address: 'Sao Paŭlo urbocentro',
        state: 'Sao Paŭlo',
        state_code: 'SP',
        country: 'Brazil',
        country_code: 'BR'
      }
    ]
  )
  Geocoder::Lookup::Test.add_stub(
      'Ĵoan-Pesoo, BR', [
      {
        coordinates: [-7.11, -34.86],
        address: 'Centro',
        state: 'Paraíba',
        state_code: 'PB',
        country: 'Brazil',
        country_code: 'BR'
      }
  ]
  )
  Geocoder::Lookup::Test.set_default_stub(
    [
      {
        coordinates: [40.71, -74.00],
        address: 'New York, NY, USA',
        state: 'New York',
        state_code: 'NY',
        country: 'United States',
        country_code: 'US'
      }
    ]
  )

  # Timezone agordoj por provkodoj
  ::Timezone::Lookup.config(:test)
  ::Timezone::Lookup.lookup.stub(40.71, -74.00, 'America/New_York')
  ::Timezone::Lookup.lookup.stub(-23.55, -46.63, 'America/Sao_Paulo')
  ::Timezone::Lookup.lookup.stub(-7.11, -34.86, 'America/Fortaleza')
  ::Timezone::Lookup.lookup.stub(43.66590881347656, -79.38521575927734, 'America/Toronto')
  ::Timezone::Lookup.lookup.default('Etc/UTC')
end
