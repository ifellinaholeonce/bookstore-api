# frozen_string_literal: true

class GithubWebhooksController < ApplicationController
  before_action :transform_params

  def webhook
    render json: {errors: 'Mismatched Secret'}, status: :forbidden unless verify_signature(request.body.read)
    event = JSON.parse(request.body.read)
    method = 'handle_' + event['action']
    send method, event
  end

  def handle_opened(_event)
    @author = Author.new(author_params)
    Author.transaction do
      @author.save
      @author.books.new(
        title: Faker::Book.title,
        price: rand(5..50),
        publisher: @author
      ).save
      render json: { status: :ok }
    end
  rescue ActiveRecord::RecordInvalid => exception
    render json: exception.message, status: :unprocessable_entity
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
    params.require(:author).permit(:name, :biography)
  end

  def transform_params
    params[:author] = {
      name: params[:issue][:title],
      biography: params[:issue][:body]
    }
  end

  def verify_signature(payload_body)
    return true if Rails.env.eql?('test')
    return false unless request.env['HTTP_X_HUB_SIGNATURE'].present?

    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), Rails.application.credentials.github[:webhook_secret], payload_body)
    return false unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end
end
