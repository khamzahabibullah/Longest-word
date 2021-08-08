require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = 10.times.map { alphabet.sample }
  end

  def score
    @word = params[:word]
    @grid = params[:grid].split('')
    @display_message = display_message
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def included?
    @word.upcase.chars.all? { |letter| @word.upcase.chars.count(letter) <= @grid.count(letter) }
  end

  def display_message
    if included?
      if english_word?(@word)
        "Congratulation! #{@word.upcase} is a valid word."
      else
        "Sorry but #{@word.upcase} is not a valid English word..."
      end
    else
      "Sorry but #{@word.upcase} can't be build out of #{@grid.join(', ')}"
    end
  end
end
