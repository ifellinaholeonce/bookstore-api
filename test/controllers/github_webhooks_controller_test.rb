require 'test_helper'

class GithubWebhooksControllerTest < ActionDispatch::IntegrationTest
  class OpenIssue < GithubWebhooksControllerTest
    setup do
      @payload = { action: 'opened', issue: {title: 'MyAuthor', body: 'MyPayloadBody'}}
    end
    test 'it creates a new author with a book' do
      assert_difference ['Author.count', 'Book.count'], 1 do
        post github_webhook_path, params: @payload, as: :json
      end
    end
  end
end
