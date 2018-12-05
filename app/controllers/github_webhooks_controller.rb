# frozen_string_literal: true

class GithubWebhooksController < ApplicationController
  before_action :transform_params

  def webhook
    render json: {errors: 'Bad Secret'}, status: :forbidden and return unless verify_signature(request.body.read)
    event = JSON.parse(request.body.read)
    method = 'handle_' + event['action']
    send method, event
  end

  def handle_opened(_event)
    @author = Author.new(author_params)
    if @author.create_with_book
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
    params.require(:author).permit(:name, :biography)
  end

  def transform_params
    params[:author] = {
      name: params[:issue][:title],
      biography: params[:issue][:body]
    }
  end

  def verify_signature(payload_body)
    return false unless request.env['HTTP_X_HUB_SIGNATURE'].present?

    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), Rails.application.credentials.github[:webhook_secret], payload_body)
    return Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end
end
