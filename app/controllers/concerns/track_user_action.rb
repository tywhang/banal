module TrackUserAction
  extend ActiveSupport::Concern

  included do
    before_filter :track_page_visit
  end

  def track_page_visit
    demo_project.track_event(
      current_actor,
      :visit,
      page_description
    )
  end

  def demo_project
    @demo_project ||= Project.find_by!(name: Project::DEMO_NAME)
  end

  def current_actor
    {
      name: 'Anonymous',
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
