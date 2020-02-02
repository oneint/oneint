namespace :generate_external_test_data do
  USER_IDS = [33332, 12346, 12347]
  task :mixpanel, [:workspace_id] => :environment do |t, args|
    integrations = Workspace.find(args[:workspace_id].to_i).integrations.joins(:application).where('applications.name': 'Mixpanel')
    integrations.each do |integration|
      tracker = Mixpanel::Tracker.new(integration.oauth_token)
      USER_IDS.each do |user_id|
        tracker.people.set(user_id, {
          '$first_name'       => "John",
          '$last_name'        => "Doe #{user_id}",
          '$email'            => 'john.doe@example.com',
          '$phone'            => '5555555555',
          'Favorite Color'    => 'red'
        }, ip = 0, {'$ignore_time' => 'true'})
        tracker.track(user_id, "New message")
      end
    end
  end
end
