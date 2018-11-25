# frozen_string_literal: true

require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:one)
    @author = authors(:valid_author)
  end

  test 'should get index' do
    get books_url, as: :json
    assert_response :success
  end

  test 'should create book' do
    assert_difference('Book.count') do
      post books_url, params: {
        "data": {
          "attributes": {
            "title": 'Ember and Coal',
            "price": 9.99
          },
          "relationships": {
            "author": {
              "data": {
                "type": 'authors',
                "id": @author.id.to_s
              }
            },
            "publisher": {
              "data": {
                "type": 'authors',
                "id": @author.id.to_s
              }
            }
          },
          "type": 'books'
        }
      }, as: :json
    end

    assert_response 201
  end

  test 'should show book' do
    get book_url(@book), as: :json
    assert_response :success
  end

  test 'should update book' do
    patch book_url(@book), params: { book: { author_id: @book.author_id, price: @book.price, publisher_id: @book.publisher_id, publisher_type: @book.publisher_type, title: @book.title } }, as: :json
    assert_response 200
  end

  test 'should destroy book' do
    assert_difference('Book.count', -1) do
      delete book_url(@book), as: :json
    end

    assert_response 204
  end
end
