# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/event_mailer
class EventMailerPreview < ActionMailer::Preview
  def send_updates_to_followers
    # event = Event.order("RANDOM()").first
    event = Event.find(6)
    EventMailer.send_updates_to_followers(event)
  end

  def notify_users
    EventMailer.notify_user(Event.order('RANDOM()').first.id, NotificationList.order('RANDOM()').first.id)
  end

  def weekly_summary
    EventMailer.weekly_summary(User.receives_weekly_summary.sample(1).first)
  end

  def informi_pri_problemo_en_evento
    params = { name: Faker::Name.name, email: Faker::Internet.email, message: Faker::Lorem.paragraph( sentence_count: 6) }
    EventMailer.kontakti_organizanton(Event.all.sample.code, params)
  end

  def informas_adm_pri_novaj_eventoj
    EventMailer.notify_admins(Event.order('RANDOM()').first.id)
  end

  def nova_administranto
    EventMailer.nova_administranto(Event.venontaj.sample)
  end

  def rememorigas_uzantojn_pri_evento
    EventMailer.rememorigas_uzantojn_pri_evento(Event.venontaj.sample.id)
  end
end
