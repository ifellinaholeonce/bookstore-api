# frozen_string_literal: true

require 'test_helper'

class BookTest < ActiveSupport::TestCase
  setup do
    @valid_book = books(:one)
  end
  test 'it validates presence of title' do
    assert @valid_book.valid?
    @valid_book.title = nil
    assert_not @valid_book.valid?
  end
  test 'it must have a positive integer for price' do
    assert @valid_book.valid?
    @valid_book.price = nil
    assert_not @valid_book.valid?
    @valid_book.price = 10
    assert @valid_book.valid?
    @valid_book.price = -10
    assert_not @valid_book.valid?
  end
end
