class SpelunkController < ApplicationController
  def index
  end

  def crawl
    url = params[:url]
    depth = params[:depth].to_i
    c = Crawler.new(url, depth)
    Image.delete_all
    c.delay.crawl
  end

  def photo
    image = Image.where(:viewed => false).order(:id).first
    if image
      image.viewed = true
      image.save
    end
    render :json => image
  end
end
