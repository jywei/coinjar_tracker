class CurrenciesController < ApplicationController
  PRICES_CACHE_EXPIRATION = 1.minute
  PRICES_CACHE_KEY = "currencies_with_latest_prices"
  PRICES_SHOWN_PER_PAGE = 20

  before_action :set_currency, only: [ :show ]

  def index
    @currencies = Rails.cache.fetch(PRICES_CACHE_KEY, expires_in: PRICES_CACHE_EXPIRATION) do
      Currency.includes(:price_snapshots).ordered.map do |currency|
        {
          currency: currency,
          latest_price: currency.latest_price
        }
      end
    end
  end

  def show
    @price_snapshots = @currency.price_snapshots.recent.page(params[:page]).per(PRICES_SHOWN_PER_PAGE)
  end

  def capture_prices
    begin
      results = PriceCaptureService.capture_all

      if results[:errors].any?
        flash[:warning] = "Captured prices for #{results[:success].join(', ')}. Errors: #{results[:errors].map { |e| "#{e[:symbol]}: #{e[:error]}" }.join(', ')}"
      else
        flash[:notice] = "Successfully captured prices for all currencies"
      end

      Rails.cache.delete(PRICES_CACHE_KEY)
      Currency.find_each do |currency|
        Rails.cache.delete_matched([ "currency", currency.id, "snapshots", "*" ])
      end

    rescue StandardError => e
      flash[:error] = "Failed to capture prices: #{e.message}"
      Rails.logger.error("Price capture failed: #{e.message}")
    end

    redirect_to currencies_path
  end

  private

  def set_currency
    @currency = Currency.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Currency not found"
    Rails.logger.error("Currency not found: #{params[:id]}")

    redirect_to currencies_path
  end
end
