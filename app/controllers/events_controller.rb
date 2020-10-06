# frozen_string_literal: true

class EventsController < ApplicationController
  rescue_from ActionController::UnknownFormat do |e|
    redirect_to root_url, flash: { error: 'Formato ne ekzistas.' }
  end
  include Webcal
  before_action :authenticate_user!, only: %i[index new create edit update destroy nova_importado importi]
  before_action :set_event, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[edit update destroy]
  before_action :filter_events, only: %i[by_continent by_country by_city]
  before_action :validate_continent, only: %i[by_continent by_country by_city]
  before_action :set_country, only: %i[by_country by_city]

  invisible_captcha only: :kontakti_organizanton, honeypot: :tiel, on_spam: :spam_detected

  # Montras la uzantajn eventojn
  def index
    @events = Event.includes(:country).by_user(current_user).order(date_start: :desc)
  end

  def show
    @horzono = cookies[:horzono] || params[:horzono] || @event.time_zone

    respond_to do |format|
      format.html
      format.ics { kreas_webcal(@event) }
    end
  end

  def new
    if params[:from_event].present?
      origin = Event.find(params[:from_event])
      attributes = origin.attributes.except('content', 'code', 'user_id', 'short_url')
      @event = Event.new(attributes)
      @event.date_start = attributes['date_start'].in_time_zone(attributes['time_zone'])
      @event.date_end = attributes['date_end'].in_time_zone(attributes['time_zone'])
      @event.specolisto = origin.specolisto
      @event_organization_ids = origin.organizations.pluck(:id)
      @event.user_id = origin.user_id
    else
      @event = Event.new
      @event.city = current_user.city if current_user.city?
      @event.country_id = current_user.country_id if current_user.country_id?
      @event.date_start = DateTime.new(Date.today.year, Date.today.month, Date.today.day, 0, 0, 0 , '0')
      @event.date_end = @event.date_start
    end
  end

  def edit
    @event_organization_ids = @event.organizations.pluck(:organization_id)
  end

  def create
    @event = Event.new(event_params)
    @event.user_id ||= current_user.id

    if @event.save
      @event.update_event_organizations(params[:organization_ids])
      # EventMailer.send_notification_to_users(event_id: @event.id)
      #EventMailer.notify_admins(@event.id).deliver_later(wait: 5.minutes)
      NovaEventaSciigoJob.perform_now(@event)
      redirect_to event_path(@event.ligilo), flash: { notice: 'Evento sukcese kreita.' }
    else
      render :new
    end
  end

  def update
    if dosier_alshutado
      redirect_to(event_url(@event.ligilo), flash: { error: 'Vi devas unue elekti dosieron' }) && return if params[:event].nil?
      @event.update(params.require(:event).permit(uploads: []))
      redirect_to event_path(@event.ligilo)
    else
      if @event.update(event_params)
        EventoGhisdatigitaJob.perform_now(@event)
        EventMailer.nova_administranto(@event).deliver_later if @event.saved_change_to_user_id?
        #EventMailer.notify_admins(@event.id, ghisdatigho: true).deliver_later
        @event.update_event_organizations(params[:organization_ids])

        redirect_to event_path(@event.ligilo), notice: 'Evento sukcese ĝisdatigita'
      else
        render :edit
      end
    end
  end

  def destroy
    redirect_to(event_path(@event.ligilo), flash: { error: 'Vi ne rajtas forigi ĝin' }) && return unless user_is_owner_or_admin(@event)

    # Ne vere forviŝas la eventon el la datumbazo, sed kaŝas ĝin
    @event.delete!
    redirect_to root_url, flash: { error: 'Evento sukcese forigita' }
  end

  def nuligi
    e = Event.lau_ligilo(params[:event_code])
    e.update(cancelled: true, cancel_reason: params[:cancel_reason])
    redirect_to event_url(params[:event_code])
  end

  def malnuligi
    e = Event.lau_ligilo(params[:event_code])
    e.update(cancelled: false, cancel_reason: nil)
    redirect_to event_url(params[:event_code])
  end

  def nova_importado
  end

  def importi
    datumoj = Importilo.new(params[:url]).datumoj
    if datumoj # Signifas ke la importado sukcesi kolekti informojn kaj eraroj ne troviĝis
      evento            = Event.new(datumoj)
      evento.user_id    = current_user.id
      evento.specolisto   = 'Alia'
      evento.import_url = params[:url]
      evento.save!
      redirect_to event_url(evento.code)
    else
      # Eraro okazis
      redirect_to importi_url, flash: { error: 'Importado malsukcesis' }
    end
  end

  def delete_file
    event = Event.by_code(params[:event_code])
    event.uploads.find(params[:file_id]).purge_later
    redirect_to event_path(event.ligilo), flash: { success: 'Dosiero sukcese forigita' }
  end

  def by_continent
    if params[:continent] == 'Reta' && cookies[:vidmaniero] == 'mapo'
      cookies[:vidmaniero] = { value: 'kalendaro', expires: 2.weeks, secure: true }
      redirect_to events_by_continent_path('Reta')
    end

    @future_events = Event.by_continent(params[:continent]).venontaj
    @events        = @events.by_continent(params[:continent])
    @countries     = @events.count_by_country
    @today_events  = @events.today.includes(:country)
    @events        = @events.not_today.includes(:country)

    kreas_paghadon_por_karta_vidmaniero
  end

  def by_country
    redirect_to(root_path, flash: { error: 'Lando ne ekzistas en la datumbazo' }) && return if @country.nil?

    @future_events = Event.includes(:country).by_country_id(@country.id).venontaj
    @cities        = @events.by_country_id(@country.id).count_by_cities
    @today_events  = @events.today.includes(:country).by_country_id(@country.id)
    @events        = @events.not_today.includes(:country).by_country_id(@country.id)

    kreas_paghadon_por_karta_vidmaniero
  end

  # Listigas la eventoj laŭ urboj
  def by_city
    redirect_to root_url, flash: { error: 'Lando ne ekzistas' } if Country.find_by(name: params[:country_name]).nil?

    @future_events = Event.by_city(params[:city_name]).venontaj
    @today_events  = @events.today.includes(:country).by_city(params[:city_name])
    @events        = @events.not_today.by_city(params[:city_name])

    kreas_paghadon_por_karta_vidmaniero
  end

  def by_username
    redirect_to root_path, flash: { error: 'Uzantnomo ne ekzistas' } if User.find_by(username: params[:username]).nil?

    @uzanto = User.find_by(username: params[:username])
    @venontaj = Event.joins(:country).by_username(params[:username]).venontaj

    @pasintaj = Event.joins(:country).by_username(params[:username]).pasintaj
    @pagy, @pasintaj = pagy(@pasintaj)
  end

  def kontakti_organizanton
    unless params[:sekurfrazo].strip.downcase == 'esperanto'
      ligilo = Event.by_code(params[:event_code]).ligilo
      redirect_to(event_url(ligilo), flash: { error: 'Sekurfrazo ne valida' }) and return
    end

    informoj = { name: params[:name], email: params[:email], message: params[:message] }
    EventMailer.kontakti_organizanton(params[:event_code], informoj).deliver_later
    redirect_to event_url(params[:event_code]), flash: { info: 'Mesaĝo sendita' }
  end

  def kronologio
    @evento = Event.lau_ligilo(params[:event_code])
  end

  private

  # La karta vidmaniero uzas paĝadon. La aliaj ne. Tial necesas krei la variablojn
    # +@kvanto_venontaj_eventoj+ kaj +@pagy+
    #
    def kreas_paghadon_por_karta_vidmaniero
      return unless cookies[:vidmaniero] == 'kartoj'

      @kvanto_venontaj_eventoj = @events.count
      @pagy, @events           = pagy(@events.not_today.includes(%i[country organizations]))
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.lau_ligilo(params[:code])
      redirect_to root_path, flash: { error: 'Evento ne ekzistas' } if @event.nil?
    end

    def set_country
      @country = Country.by_name(params[:country_name])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      if params[:event][:date_start].present? # TODO: Arrumar - por conta do envio de arquivos
        params[:event][:date_start] = merge_date_time(params[:event][:date_start], params[:time_start],
                                                      params[:event][:time_zone])
        params[:event][:date_end] = merge_date_time(params[:event][:date_end], params[:time_end],
                                                    params[:event][:time_zone])

        params[:event][:specolisto] = if params[:specolisto].present?
                                      params[:specolisto].keys.collect { |k, _v| k }.join(', ')
                                    else
                                      ''
                                    end
      end

      params[:event][:commit] = params[:commit]

      params.require(:event).permit(
        :title, :description, :enhavo, :site, :email, :date_start, :date_end, :time_zone,
        :address, :city, :country_id, :online, :user_id, :specolisto, :short_url, uploads: []
      )
    end

    # Nur la permesataj uzantoj povas redakti, ĝisdatiĝi kaj foriĝi la eventon
    def authorize_user
      unless user_can_edit_event?(user: current_user, event: @event)
        redirect_to root_url, flash: { error: 'Vi ne rajtas' }
      end
    end

    def validate_continent
      continent_names = Country.pluck(:continent).uniq

      if params[:continent].normalized.in? continent_names.map(&:normalized)
        @continent = Country.continent_name(params[:continent])
      else
        redirect_to root_url, flash: { notice: 'Ne estas eventoj en tiu kontinento' }
      end
    end

    def merge_date_time(date, time, _time_zone)
      # DateTime.strptime("#{date} #{time}", '%d/%m/%Y %H:%M')
      # "#{date} #{time}".in_time_zone(time_zone)
      "#{date} #{time}"
    end

    def spam_detected
      redirect_to root_path
    end

    def dosier_alshutado
      params[:commit] == 'Sendi'
    end
end
