FactoryGirl.define do
  factory :event_hash, class: Hash do
    client_timestamp '2015-01-01T10:15:20'

    initialize_with { attributes }
  end

  factory :event, class: InhouseEvents::Event do
    client_timestamp '2015-01-01T10:15:20'

    initialize_with { new(attributes) }
  end
end
