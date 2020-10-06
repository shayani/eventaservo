class SciigasUzantojnAntauEventoJob < ApplicationJob
  queue_as :rememoriga_mesagho

  def perform(evento_id)
    e = Event.find(evento_id)
    # return unless e.participants.any?

    EventMailer.rememorigas_uzantojn_pri_evento(evento_id).deliver_later
  end
end
