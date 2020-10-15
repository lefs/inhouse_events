module InhouseEventsHelper
  def self.ignore_events(*events)
    events_to_ignore = JSON.dump(events.empty? ? true : events)

    <<-HTML.html_safe
    <script>
      (InhouseEvents = typeof InhouseEvents === "object" ? InhouseEvents : {}).skipEvents = #{events_to_ignore};
    </script>
    HTML
  end
end
