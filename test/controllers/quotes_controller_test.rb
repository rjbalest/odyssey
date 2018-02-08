require 'test_helper'

class QuotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @quote = quotes(:one)
  end

  test "should get index" do
    get quotes_url
    assert_response :success
  end

  test "should get new" do
    get new_quote_url
    assert_response :success
  end

  test "should create quote" do
    assert_difference('Quote.count') do
      post quotes_url, params: { quote: { adjusted_close: @quote.adjusted_close, close: @quote.close, date: @quote.date, dividend: @quote.dividend, high: @quote.high, low: @quote.low, open: @quote.open, split_coefficient: @quote.split_coefficient, ticker: @quote.ticker, volume: @quote.volume } }
    end

    assert_redirected_to quote_url(Quote.last)
  end

  test "should show quote" do
    get quote_url(@quote)
    assert_response :success
  end

  test "should get edit" do
    get edit_quote_url(@quote)
    assert_response :success
  end

  test "should update quote" do
    patch quote_url(@quote), params: { quote: { adjusted_close: @quote.adjusted_close, close: @quote.close, date: @quote.date, dividend: @quote.dividend, high: @quote.high, low: @quote.low, open: @quote.open, split_coefficient: @quote.split_coefficient, ticker: @quote.ticker, volume: @quote.volume } }
    assert_redirected_to quote_url(@quote)
  end

  test "should destroy quote" do
    assert_difference('Quote.count', -1) do
      delete quote_url(@quote)
    end

    assert_redirected_to quotes_url
  end
end
