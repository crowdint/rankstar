require 'rubygems'
require 'nokogiri'
require 'net/http'

class Rankstar
  ENGINES = [:google, :yahoo, :bing]
  def self.rank(engine, *args)
    validate_engine(engine)
    validate_options(args[:options])
  end

  private
  def self.validate_engine(engine)
    raise "Allowed engines are: :google, :yahoo, :bing" unless ENGINES.include?(engine)
  end
  
  def self.validate_options(options)
    raise "You should specify a :keyword option" unless options[:keyword]
    raise "You should specify a :site option" unless options[:site]
  end
end