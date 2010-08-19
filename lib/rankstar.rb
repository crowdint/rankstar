require 'rubygems'
require 'nokogiri'
require 'net/http'

class Rankstar
  ENGINES = [:google, :yahoo, :bing]
  def self.rank(engine, keyword, url, *args)
    validate_engine(engine)
    options = {:res_per_page => 100, :limit => 100}
    options.merge!(args[0])

    keyword.gsub!(/\s/, '+')
    request_url, results_selector, cite_selector = prepare_for(engine, keyword, options[:res_per_page])
    fetch_the_rank(request_url, results_selector, cite_selector, url, options[:limit], options[:res_per_page])
  end

  private
  def self.validate_engine(engine)
    raise "Allowed engines are: :google, :yahoo, :bing" unless ENGINES.include?(engine)
  end

  def self.prepare_for(engine, keyword, results_per_page)
    case engine
    when :bing
      ["http://www.bing.com/search?q=#{keyword}&count=#{results_per_page}&first=", '#wg0 > li', 'cite']
    when :google
      ["http://www.google.com/search?q=#{keyword}&num=#{results_per_page}&start=", '#ires > ol > li', 'cite']
    when :yahoo
      ["http://search.yahoo.com/search?p=#{keyword}&n=#{results_per_page}&b=", '#web > ol > li', 'span']
    end
  end

  def self.fetch_the_rank(request_url, results_selector, cite_selector, url, limit, results_per_page)
    count, rank = 0, nil

    loop {
      html_response = Net::HTTP.get_response(URI.parse("#{request_url}#{count}")).body
      html_results = Nokogiri.parse(html_response).css(results_selector)
      rank = html_results.index(html_results.detect{ |result| result.css(cite_selector).text.match Regexp.new(url) })

      if count > limit
        break
      elsif rank
        rank += count
        break
      end
      count += results_per_page
    }
    rank ? rank.next : nil
  end
end