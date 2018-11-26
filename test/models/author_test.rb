# frozen_string_literal: true

require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
  setup do
    @valid_author = authors(:valid_author)
  end
  test 'it validates presence of name' do
    assert @valid_author.valid?
    @valid_author.name = nil
    assert_not @valid_author.valid?
  end
end
