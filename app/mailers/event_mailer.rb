# frozen_string_literal: true

class EventMailer < ApplicationMailer
  add_template_helper ApplicationHelper
  add_template_helper EventsHelper

  require 'redcarpet/render_strip'

  def self.send_notification_to_users(event_id:)
    return false unless Event.exists?(event_id)
    return false unless Rails.env.production? # Ne sendas retmesaĝon dum provo

    event      = Event.includes(:country).find(event_id)
    recipients = event.country.recipients
    return false if recipients.empty?

    recipients.each do |recipient|
      notify_user(event_id, recipient.id).deliver_later(wait: 1.hour)
    end
  end

  def notify_user(event_id, recipient_id)
    @recipient = NotificationList.find(recipient_id)
    @event     = Event.includes(:country).find(event_id)
    mail(to: @recipient.email, subject: "Nova evento: #{@event.title}")
  end

  def notify_admins(event_id, ghisdatigho: false)
    return false if Rails.env.development?

    @event = Event.find(event_id)
    if ghisdatigho
      subject = "[ES estraro] Ĝisdatiĝo: #{@event.title}"
      to = 'yves.nevelsteen@gmail.com'
    else
      subject = "[ES estraro] Nova evento: #{@event.title}"
      to = Constants::ADMIN_EMAILS
    end
    mail(to: to, subject: subject)
  end

  def self.send_weekly_summary_to_users
    User.receives_weekly_summary.each do |user|
      EventMailer.weekly_summary(user).deliver_later
    end
  end

  def weekly_summary(user)
    @events = Event.by_dates(from: Time.zone.today, to: Time.zone.today + 7.days)
    # @user = user
    @user = User.find(1) # Nur por provoj
    mail(to: "#{user.name.delete(',')} <#{user.email}>", subject: 'Tutmonda semajna resumo de eventoj')
  end

  def kontakti_organizanton(eventa_kodo, informoj = {})
    @evento = Event.by_code(eventa_kodo)
    @informoj = informoj

    if Rails.env.production?
      to = @evento.user.email
      bcc = Constants::ADMIN_EMAILS
    else
      to = Constants::ADMIN_EMAILS
      bcc = nil
    end

    mail(to: to, bcc: bcc, reply_to: informoj[:email],
         subject: 'Informo pri via evento en Eventa Servo')
  end

  def nova_administranto(evento)
    @evento = evento

    if Rails.env.production?
      to = evento.user.email
      bcc = Constants::ADMIN_EMAILS
    else
      to = Constants::ADMIN_EMAILS
      bcc = nil
    end

    mail(to: to, bcc: bcc, subject: 'Vi estas nova eventa administranto')
  end

  def rememorigas_uzantojn_pri_evento(evento_id)
    @evento = Event.find(evento_id)
    to = 'shayani@gmail.com'

    mail(to: to, subject: "[ES] #{@evento.title} baldaŭ komenciĝos")
  end
end
