class NovaUzantoSciigoJob < ApplicationJob
  queue_as :default

  def perform(uzanto)
    return true if Rails.env == 'test' || Rails.env.development?

    mesagho = "Nova uzanto registrita:\n\n"
    mesagho += "#{uzanto.name} el #{uzanto.city} (#{uzanto.country.code.upcase})\n\n"
    mesagho += events_by_username_url(uzanto.username) unless uzanto.username.nil?
    system "telegram-send --config config/es_admin_channel.conf \"#{mesagho}\""
  end
end
