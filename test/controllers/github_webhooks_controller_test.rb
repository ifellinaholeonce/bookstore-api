# frozen_string_literal: true

require 'test_helper'

class GithubWebhooksControllerTest < ActionDispatch::IntegrationTest
  class OpenIssue < GithubWebhooksControllerTest
    setup do
      @payload = { action: 'opened', issue: { title: 'MyAuthor', body: 'MyPayloadBody' } }
    end
    test 'it creates a new author with a book' do
      assert_difference ['Author.count', 'Book.count'], 1 do
        post github_webhook_path, params: @payload, as: :json
      end
    end
  end

  class EditIssue < GithubWebhooksControllerTest
    setup do
      @author = authors(:valid_author)
      @payload = { action: 'edited', issue: { title: @author.name, body: 'MyNewPayloadBody' } }
    end
    test 'it updates the bio for an author' do
      assert_equal 'MyBiography', @author.biography
      post github_webhook_path, params: @payload, as: :json
      @author.reload
      assert_equal 'MyNewPayloadBody', @author.biography
    end
  end

  class DeleteIssue < GithubWebhooksControllerTest
    setup do
      @author = authors(:valid_author)
      @payload = { action: 'deleted', issue: { title: @author.name, body: 'MyPayloadBody' } }
    end
    test 'it deletes the author and books' do
      assert_difference 'Author.count', -1 do
        assert_difference 'Book.count', -2 do
          post github_webhook_path, params: @payload, as: :json
        end
      end
    end
  end
end
