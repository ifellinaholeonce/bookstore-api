# frozen_string_literal: true

class GithubWebhooksController < ApplicationController
  require 'faker'

  def webhook
    event = JSON.parse(request.body.read)
    method = 'handle_' + event['action']
    send method, event
  end

  def handle_opened(_event)
    @author = Author.new(author_params)
    if @author.save
      @author.books.new(
        title: Faker::Book.title,
        price: rand(5..50),
        publisher: @author
      ).save
      render json: { status: :ok }
    else
      render json: @author.errors, status: :unprocessable_entity
    end
  end

  def handle_edited(event)
    @author = Author.find_by(name: event['issue']['title'])
    return render json: {
      errors: "Editing Issue titles not currently supported. Author not updated."
    }, status: :unprocessable_entity unless @author.present?
    if @author.update(author_params)
      render json: { status: :ok }
    else
      render json: @author.errors, status: :unprocessable_entity
    end
  end

  def handle_deleted(event)
    Author.find_by(name: event['issue']['title']).destroy
  end

  private

  def author_params
    params.require(:issue).permit(:title, :body)
  end
end
