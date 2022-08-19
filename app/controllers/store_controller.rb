class StoreController < ApplicationController
  def index
    @products = Product.order(:title)
    @session = increment_counter
  end

  private

  def increment_counter
    if session[:counter].nil?
      session[:counter] = 0
    else
      session[:counter] += 1
    end
  end
end
