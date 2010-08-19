require 'rubygems'
require 'nokogiri'
require 'net/http'

class Rankstar
  ENGINES = [:google, :yahoo, :bing]
  def self.rank(engine, *args)
    validate_engine(engine)
    validate_options(args[0])
    options = args[0].merge({:res_per_page => 200, :limit => 100})

    options[:keyword].gsub!(/\s/, '+')
    request_url, results_selector, cite_selector = prepare_for(engine, options)
    fetch_the_rank(request_url, results_selector, cite_selector, options)
  end

  private
  def self.validate_engine(engine)
    raise "Allowed engines are: :google, :yahoo, :bing" unless ENGINES.include?(engine)
  end

  def self.validate_options(options)
    raise "You should specify a :keyword option" unless options[:keyword]
    raise "You should specify a :url option" unless options[:url]
  end

  def self.prepare_for(engine, options)
    case engine
    when :bing
      ["http://www.bing.com/search?q=#{options[:keyword]}&count=#{options[:res_per_page]}&first=", '#wg0 > li', 'cite']
    when :google
      ["http://www.google.com/search?q=#{options[:keyword]}&num=#{options[:res_per_page]}&start=", '#ires > ol > li', 'cite']
    when :yahoo
      ["http://search.yahoo.com/search?p=#{options[:keyword]}&n=#{options[:res_per_page]}&b=", '#web > ol > li', 'span']
    end
  end

  def self.fetch_the_rank(request_url, results_selector, cite_selector, options)
    count, rank = 0, nil

    loop {
      html_response = Net::HTTP.get_response(URI.parse("#{request_url}#{count}")).body
      html_results = Nokogiri.parse(html_response).css(results_selector)
      rank = html_results.index(html_results.detect{ |result| result.css(cite_selector).text.match Regexp.new(options[:url]) })

      if count > options[:limit]
        break
      elsif rank
        rank += count
        break
      end
      count += options[:res_per_page]
    }
    rank ? rank.next : nil
  end
end