class GamesController < ApplicationController
  require 'open-uri'
  require 'json'
  def new
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
    @score = params[:score] || 0
  end

  def score
    @guess = params[:guess].upcase
    @grid = params[:grid]
    @score = params[:score].to_i || 0
    @message = game(@guess, @grid)
  end

  private

  def game(guess, grid)
    guess_results = JSON.parse(URI.parse("https://dictionary.lewagon.com/#{guess}").read)
    if included?(guess, grid) && guess_results["found"]
      @score += guess.to_s.length
      return "Congratulations! #{guess} is a valid English word"
    # Result if not english
    elsif included?(guess, grid)
      return "Sorry, but #{guess} not an English word"
    # Result if not in grid
    else
      return "Sorry, but #{guess} is not in the grid"
    end
  end

  def included?(guess, grid)
    guess.upcase.chars.all? do |character|
      guess.upcase.chars.count(character) <= grid.count(character)
    end
  end
end
