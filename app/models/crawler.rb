class Crawler
  attr_accessor :url, :depth, :urls, :a_regex, :i_regex, :h_regex

  def initialize(url, depth)
    @url = url
    @depth = depth
    @urls = []
    @a_regex = /<a.*?href.*?['"](.*?)['"].*?>/m
    @i_regex = /<img.*?src.*?['"](.*?)['"].*?>/m
    @h_regex = /(https?:\/\/\w+[\.\w]+)/m
  end

  def crawl
    get_links(@url, 0)
  end

  def get_links(link, inception)
    return if @depth == inception

    begin
      domain = link.scan(@h_regex).flatten.join
      html = HTTParty.get(link)
      temp_links = html.scan(@a_regex).flatten
      temp_picts = html.scan(@i_regex).flatten

      temp_picts.each do |temp|
        begin
          temp_link = if URI.parse(temp).relative?
                        domain + temp
                      else
                        temp
                      end
          Image.create(:url => temp_link)
        rescue => e
          puts "image inner code -> #{e}, temp -> #{temp}"
        end
      end

      temp_links.each do |temp|
        begin
          temp_link = if URI.parse(temp).relative?
                        domain + temp
                      else
                        temp
                      end
          @urls << temp_link if !@urls.include?(temp_link)
          get_links(temp_link, inception+1)
        rescue => e
          puts "url inner code -> #{e}, temp -> #{temp}"
        end
      end

    rescue => e
      puts "outer code -> #{e}, link -> #{link}"
    end
  end
end
