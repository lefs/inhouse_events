require 'time'
require_dependency 'inhouse_events/application_controller'

module InhouseEvents
  class EventsController < ApplicationController
    def create
      if params[:event]
        event = params[:event].permit!.to_h
        event = event.deep_symbolize_keys
        request_event = event.merge(additional_request_info)
        InhouseEvents.queue(request_event)
      end

      render_nothing
    end

    private

    def additional_request_info
      {
        ip_address: request.ip,
        user: fetch_username,
        user_agent: request.env['HTTP_USER_AGENT'],
        session_id: request.session.id,
        server_timestamp: Time.now.utc.iso8601
      }
    end

    def fetch_username
      return unless defined? current_user

      if current_user.respond_to?(:email)
        current_user.email
      elsif current_user.respond_to?(:name)
        current_user.name
      end
    end

    def render_nothing
      # render nothing: true is deprecated in Rails 5.
      if Rails::VERSION::MAJOR >= 5
        head :ok
      else
        render nothing: true
      end
    end
  end
end
