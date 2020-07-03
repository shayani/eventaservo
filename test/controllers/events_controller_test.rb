# frozen_string_literal: true

require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  def setup
    host! 'devel.eventaservo.org:3000'
    cookies[:vidmaniero] = 'kartoj'
  end

  test 'devas listigi la validajn kontinentajn eventojn' do
    valid_continents = %w[
      /Afriko
      /afriko
      /Ameriko
      /ameriko
      /Azio
      /azio
      /Euxropo
      /euxropo
      /E%C5%ADropo
      /e%C5%ADropo
      /Oceanio
      /oceanio
      /Reta
    ]

    create(:lando, :brazilo)
    create(:lando, :togolando)
    create(:lando, :australio)
    create(:lando, :cehio)
    create(:lando, :japanio)
    create(:lando, :reta)
    valid_continents.each do |continent|
      get continent
      assert_response :success
    end
  end

  test 'redirektas /reta al /Reta' do
    create(:lando, :reta)
    get '/reta'
    assert_redirected_to '/Reta'
  end

  test 'devas montri la ĉefpaĝon se la kontinento ne ekzistas' do
    get '/NevalidaKontinento'
    assert_redirected_to root_path
    assert_equal 'Ne estas eventoj en tiu kontinento', flash[:notice]
  end

  test 'devas montri urban paĝon se urbo nomo validas' do
    create :lando, :brazilo
    get '/ameriko/brazilo'
    assert_response :success

    create :lando, :cehio
    get '/E%C5%ADropo/%C4%88e%C4%A5io'
    assert_response :success

    get '/euxropo/cxehxio'
    assert_response :success
  end

  test 'direktas la uzanton al ĉefapaĝo se uzantnomo ne ekzistas' do
    get '/uzanto/ne_valida_uzantnomo'
    assert_redirected_to root_path
    assert_equal 'Uzantnomo ne ekzistas', flash[:error]
  end
end
