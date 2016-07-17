get '/' do
  redirect '/homepage'
end

get '/homepage' do
  p params
  p session
  session[:card_ids_in_play] = nil
  session[:round_info] = nil
  @decks = Deck.all

  erb :'homepage/index'
end

get '/decks/:deck_id/cards/:card_id' do

  @current_deck = Deck.find(params[:deck_id])
  @current_card = Card.find(params[:card_id])
  session[:card_ids_in_play] ||= @current_deck.cards.map(&:id)

  # if session[:card_ids_in_play].length == 0
  #   erb :'rounds/show'
  # end

  if session[:round_info].nil?
    session[:round_info] = {}
    session[:round_info][:guesses] ||= 0
    session[:round_info][:correct] ||= 0
    session[:round_info][:deck_id] ||= @current_deck.id
    session[:round_info][:user_id] ? @current_user.id : 0
  end


  if params[:user_guess] == @current_card.answer
    @result_response = "Correct! The answer is: #{@current_card.answer}"
    session[:card_ids_in_play].delete(@current_card.id)
    session[:round_info][:guesses] += 1
    session[:round_info][:correct] += 1
  elsif params[:user_guess].nil? == false
    session[:round_info][:guesses] += 1
    @result_response = "WRONG! The answer was: #{@current_card.answer}"
  end

  p params
  p session

  erb :'deck/index'
end

get '/rounds/show' do


erb :'rounds/show'
end

