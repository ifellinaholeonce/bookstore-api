namespace :github_api do
  desc 'Create an issue on the github repo'
  task create_issue: :environment do
    github = Github.new client_id: Rails.application.credentials.github[:client_id],
                        client_secret: Rails.application.credentials.github[:client_secret],
                        oauth_token: Rails.application.credentials.github[:token]
    github.issues.create(
      Rails.application.credentials.github[:user],
      Rails.application.credentials.github[:repo],
      title: 'Rake Create with Oauth',
      description: 'Creating with Rake Task'
    )
  end
end
