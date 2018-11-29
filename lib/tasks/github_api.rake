# frozen_string_literal: true

namespace :github_api do
  desc 'Create webhook on the github repo'
  task create_webhook: :environment do
    url = ENV['WEBHOOK_URL'] + '/github'
    github = Github.new client_id: Rails.application.credentials.github[:client_id],
                        client_secret: Rails.application.credentials.github[:client_secret],
                        oauth_token: Rails.application.credentials.github[:token]
    github.repos.hooks.create(
      Rails.application.credentials.github[:user],
      Rails.application.credentials.github[:repo],
      name: 'web',
      active: true,
      events: [
        'issues'
      ],
      config: {
        url: url,
        secret: Rails.application.credentials.github[:webhook_secret],
        content_type: 'json'
      }
    )
    puts "Issues webhook created for #{Rails.application.credentials.github[:repo]} pointed to #{url}"
  end
  desc 'Create an issue on the github repo'
  task create_issues: :environment do
    github = Github.new client_id: Rails.application.credentials.github[:client_id],
                        client_secret: Rails.application.credentials.github[:client_secret],
                        oauth_token: Rails.application.credentials.github[:token]
    10.times do
      github.issues.create(
        Rails.application.credentials.github[:user],
        Rails.application.credentials.github[:repo],
        title: Faker::Book.author,
        body: Faker::HitchhikersGuideToTheGalaxy.quote
      )
    end
  end
end
