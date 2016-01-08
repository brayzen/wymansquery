
class WelcomeController < ApplicationController
  require 'time'

  def index
    puts "$$$$$$$$$$$$"
    puts "query_params: #{query_params}"
    puts "$$$$$$$$$$$$"
    if query_params
      format_dates
      queery = query_params[:queery]
      limit = query_params[:limit]
      response = HTTParty.get("http://api.boardreader.com/v1/Boards/Search?&offset=0&limit=#{limit}&query=#{queery}&group_mode=post&filter_date_from=#{@date_from}&filter_date_to=#{@date_to}&sort_mode=default&filter_language=&dn=&body=snippet&mode=full&match_mode=extended&key=#{Rails.application.secrets.wy_api_key}")
      puts '%%%%%%%%%%%%%%%%%%%%%%%%%%'
      puts '%%%%%%%%%%%%%%%%%%%%%%%%%%'
      puts response["Response"]["Request"]["key"]
      puts '%%%%%%%%%%%%%%%%%%%%%%%%%%'
      puts '%%%%%%%%%%%%%%%%%%%%%%%%%%'
      if response["Response"]["Matches"]
        matches = response["Response"]["Matches"]["Match"]
        winners = ["Country", "Language", "Crawled", "Url", "Text", "Subject", "Published"]
        @keys = matches[0].keys.select{ |winner| winners.include?(winner) }
        @matches = matches.map { |match| match }
      else
        @keys, @matches = [], ['No Matches Found']
      end
    else
      @keys, @matches = [], []
    end
  end

  private

  def format_dates
    @date_from = Date.new(query_params[:"date_from(1i)"].to_i, query_params[:"date_from(2i)"].to_i, query_params[:"date_from(3i)"].to_i).to_time.to_i
    @date_to = Date.new(query_params[:"date_to(1i)"].to_i, query_params[:"date_to(2i)"].to_i, query_params[:"date_to(3i)"].to_i).to_time.to_i
  end

  def query_params
    if params["query"]
      params.require(:query).permit(:queery, :limit, :"date_from(1i)", :"date_from(2i)", :"date_from(3i)", :"date_to(1i)", :"date_to(2i)", :"date_to(3i)")
    end
  end
end
