require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    guess = params[:guess]
    letters = params[:letters]
    if valid?(guess, letters) && english?(guess)
      @answer = "Congratulations! #{guess} is a valid English word!"
      session[:score] += guess.length
    elsif valid?(guess, letters) && !english?(guess)
      @answer = "Sorry but #{guess} does not seem to be a valid English word"
    else
      @answer = "Sorry but #{guess} can't be built out of #{letters}"
    end

    @score = session[:score]
  end

  private

  def english?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    x = JSON.parse(response.read)
    x['found'] == true
  end

  def valid?(word, list)
    word.upcase.chars.map { |x| list.include?(x) }.all?(true)
  end
end


