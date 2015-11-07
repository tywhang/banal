module TrackUserAction
  extend ActiveSupport::Concern

  included do
    after_filter :track_page_visit
  end

  def track_page_visit
    # We only track normal requests
    return if request.xhr? || !request.format.html?

    Project.demo.track_event(
      current_actor,
      :visit,
      page_description
    )
  end

  def current_actor
    {
      name: current_user ? current_user.name : 'Anonymous',
      id: encoded_session_id
    }
  end

  def page_description
    {
      name: request.url,
      id: request.path
    }
  end

  def encoded_session_id
    Base64.encode64(Digest::SHA256.new.digest(session.id))
  end
end
