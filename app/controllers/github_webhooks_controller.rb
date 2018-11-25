class GithubWebhooksController < ApplicationController
  def webhook
    event = JSON.parse(request.body.read)
    method = 'handle_' + event['action']
    send method, event
  end

  def handle_opened(event)
    @author = Author.new(author_params)
    if @author.save
      @author.books.new(
        title: "Biography of #{@author.name}",
        price: rand(5..50),
        publisher: @author
      ).save
      render json: {status: 200}
    else
      render_error(@author, :unprocessable_entity)
    end
  end

  private

  def author_params
    params.require(:issue).permit(:title, :body)
  end
end
