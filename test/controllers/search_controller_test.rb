# frozen_string_literal: true

require 'test_helper'

class SearchControllerTest < ActionDispatch::IntegrationTest
  class GetShow < SearchControllerTest
    test ' it returns JSON results' do
      get search_path(q: 'MyStr')
      json = JSON.parse(response.body)
      assert_equal 2, json['books'].count
      assert_equal 1, json['authors'].count
    end
  end
end
