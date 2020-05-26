# frozen_string_literal: true

module Api
  module V2
    class EventojController < ApiController

      def index

        @eventoj = Event.venontaj.order(:date_start).limit(5)
        render 'index.json.jbuilder'
      end
    end
  end
end
