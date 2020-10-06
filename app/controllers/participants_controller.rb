# frozen_string_literal: true

class ParticipantsController < ApplicationController
  def event
    event = Event.lau_ligilo(params[:event_code])
    participant = event.participants.find_by(user_id: current_user.id)

    if participant
      participant.destroy
    else
      event.add_participant(current_user, public: params[:publika] == 'jes')
    end

    redirect_to event_url(event.ligilo)
  end
end
