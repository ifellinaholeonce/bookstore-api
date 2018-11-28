# frozen_string_literal: true

class SearchController < ApplicationController
  before_action :force_json, only: :show

  def show
    return if params[:q].blank?

    search_books
    search_authors
    render json: { books: @books, authors: @authors }, status: :ok
  end

  private

  def force_json
    request.format = :json
  end

  def search_books
    @books = Book.where('title LIKE ?', "%#{params[:q]}%").limit(3)
  end

  def search_authors
    @authors = Author.where('name LIKE ?', "%#{params[:q]}%").limit(3)
  end
end
