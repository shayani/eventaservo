# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :filter_events, only: :index
  before_action :definas_kuketojn, only: :index

  def index
    @future_events = Event.venontaj
    if params[:o].present?
      @future_events = @future_events.joins(:organizations).where('organizations.short_name = ?', params[:o])
    end

    @continents    = @events.count_by_continents
    @today_events  = @events.today.includes(:country).includes(:organizations)

    @events = @events.not_today.includes(%i[country organizations])
    @reklamoj = Ad.all.sample(4)

    if cookies[:vidmaniero] == 'kartoj' # Paghado
      @kvanto_venontaj_eventoj = @events.count
      begin
        @pagy, @events = pagy(@events.not_today.includes(%i[country organizations]))
      rescue Pagy::OverflowError
        redirect_to root_url
      end
    end
  end

  def anoncoj
    @eventoj = Event.anoncoj_kaj_konkursoj
  end

  def changelog
  end

  def privateco
  end

  def prie
    render layout: 'full_size'
  end

  def robots
    robots =
      if Rails.env.production?
        File.read(Rails.root + 'config/robots.production.txt')
      else
        File.read(Rails.root + 'config/robots.staging.txt')
      end
    render plain: robots, layout: false, content_type: 'text/plain'
  end

  # Listigas la eventojn por montri per la kalendara vidmaniero
  #
  def events
    redirect_to root_url unless access_from_server

    @horzono = cookies[:horzono]
    @events = Event.ne_nuligitaj.chefaj.includes(:country)
    @events = @events.by_dates(from: params[:start], to: params[:end])
    @events = @events.by_continent(params[:continent]) if params[:continent].present?
    @events = @events.by_country_name(params[:country]) if params[:country].present?
    @events = @events.by_city(params[:city]) if params[:city].present?
    @events = @events.lau_organizo(params[:o]) if params[:o].present?
    @events = @events.kun_speco(params[:s]) if params[:s].present?
    @events = @events.unutagaj if params[:t] == 'unutaga'
    @events = @events.plurtagaj if params[:t] == 'plurtaga'
    @events = Event.includes(:country).by_username(params[:username]) if params[:username].present?
  end

  def feed
    @events = Event.includes(:country).includes(:user).venontaj.order(:date_start)
    render layout: false
  end

  def view_style
    cookies[:vidmaniero] = { value: params[:view_style], expires: 1.year, secure: true }
    redirect_to root_url
  end

  def search
    respond_to :js
    @events = Event.includes(:country).search(params[:query]).venontaj.grouped_by_months
  end

  def statistics
    respond_to do |format|
      format.html
      format.json do
        case params[:q]
        when 'registritaj_eventoj'
          render json: kalkulas_registritajn_eventojn
        when 'kvanto_registritaj_uzantoj'
          render json: kalkulas_kvanton_registritaj_uzantoj
        when 'kvanto_registritaj_eventoj'
          render json: kalkulas_kvanton_registritaj_eventoj
        when 'eventoj_lau_monatoj'
          render json: kalkulas_eventojn_lau_monatoj
        when 'eventoj_retaj_kaj_fizikaj'
          render json: kalkulas_eventojn_retajn_kaj_fizikajn
        else
          render json: { eraro: 'Ne valida diagramo' }
        end
      end
    end
  end

  def accept_cookies
    if params[:akceptas_ga] == 'jes'
      cookies[:akceptas_ga] = { value: 'jes', expires: 1.year }
    else
      cookies[:akceptas_ga] = { value: 'ne', expires: 1.year }
      delete_ga_cookies
    end

    respond_to do |format|
      format.js
      format.html { redirect_to root_url }
    end
  end

  def reset_cookies
    delete_ga_cookies
    cookies.delete :akceptas_ga
    redirect_to root_url
  end

  private

    # Forigas Google Analytics cookies
    def delete_ga_cookies
      cookies.delete :_ga, path: '/', domain: '.eventaservo.org'
      cookies.delete :_gid, path: '/', domain: '.eventaservo.org'
    end

    def access_from_server
      request.headers['SERVER_NAME'].in? %w[devel.eventaservo.org staging.eventaservo.org eventaservo.org]
    end

    def definas_kuketojn
      return if cookies[:vidmaniero].in? %w[kartoj kalendaro mapo]

      cookies[:vidmaniero] = { value: 'kalendaro', expires: 2.weeks, secure: true } # Normala vidmaniero
    end

    def kalkulas_registritajn_eventojn
      countries = []
      quantity = []
      Event.joins(:country).group('countries.name').order('count_id DESC, countries.name ASC').limit(15).count(:id).map do |country, qtd|
        countries << country
        quantity << qtd
      end
      { landoj: countries, kvantoj: quantity }
    end

    def kalkulas_kvanton_registritaj_uzantoj
      quantity = []
      quantity << User.where('created_at <= ?', (Time.zone.today - 5.months).end_of_month).count
      quantity << User.where('created_at <= ?', (Time.zone.today - 4.months).end_of_month).count
      quantity << User.where('created_at <= ?', (Time.zone.today - 3.months).end_of_month).count
      quantity << User.where('created_at <= ?', (Time.zone.today - 2.months).end_of_month).count
      quantity << User.where('created_at <= ?', (Time.zone.today - 1.month).end_of_month).count
      quantity << User.where('created_at <= ?', Time.zone.today.end_of_month).count

      { monatoj: last_6_months_label, kvantoj: quantity }
    end

    def kalkulas_kvanton_registritaj_eventoj
      quantity = []
      quantity << Event.where('created_at <= ?', (Time.zone.today - 5.months).end_of_month).count
      quantity << Event.where('created_at <= ?', (Time.zone.today - 4.months).end_of_month).count
      quantity << Event.where('created_at <= ?', (Time.zone.today - 3.months).end_of_month).count
      quantity << Event.where('created_at <= ?', (Time.zone.today - 2.months).end_of_month).count
      quantity << Event.where('created_at <= ?', (Time.zone.today - 1.month).end_of_month).count
      quantity << Event.where('created_at <= ?', Time.zone.today.end_of_month).count

      { monatoj: last_6_months_label, kvantoj: quantity }
    end

    def kalkulas_eventojn_lau_monatoj
      monatoj = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Maj',
        'Jun',
        'Jul',
        'Aŭg',
        'Sep',
        'Okt',
        'Nov',
        'Dec'
      ]

      quantity = []
      (1..12).each do |month|
        quantity << Event.where('extract(month from date_start) = :month OR extract(month from date_end) = :month', month: month).count
      end

      { monatoj: monatoj, kvantoj: quantity }
    end

    def kalkulas_eventojn_retajn_kaj_fizikajn
      monatoj = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Maj',
        'Jun',
        'Jul',
        'Aŭg',
        'Sep',
        'Okt',
        'Nov',
        'Dec'
      ]

      eventoj = []
      retaj = []
      fizikaj = []


      5.downto(0) do |m|
        retaj << Event.online.where(created_at: (Date.today - m.month).beginning_of_month..(Date.today - m.month).end_of_month).count
        fizikaj << Event.not_online.where(created_at: (Date.today - m.month).beginning_of_month..(Date.today - m.month).end_of_month).count
      end

      eventoj << { name: 'Fizikaj', data: fizikaj }
      eventoj << { name: 'Retaj', data: retaj }

      { eventoj: eventoj,  x_axis: last_6_months_label }
    end
end
