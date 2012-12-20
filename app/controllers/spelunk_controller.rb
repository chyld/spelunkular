class SpelunkController < ApplicationController
  def index
  end

  def crawl
    url = params[:url]
    depth = params[:depth].to_i
    c = Crawler.new(url, depth)
    c.crawl
    #session[:image_id] = Image.first.id
    render :nothing => true
  end

  def photo
    if Image.any? && session[:image_id].present?
      image = Image.where('id > ?', session[:image_id]).order(:id).first
      session[:image_id] = image.try(:id)
      render :json => image
    else
      render :json => nil
    end
  end
end
