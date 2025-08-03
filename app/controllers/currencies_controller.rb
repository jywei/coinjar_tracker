class CurrenciesController < ApplicationController
  before_action :set_currency, only: [:show]
  
  # GET /currencies
  # GET /
  def index
    @currencies = Rails.cache.fetch('currencies_with_latest_prices', expires_in: 5.minutes) do
      Currency.includes(:price_snapshots).ordered.map do |currency|
        {
          currency: currency,
          latest_price: currency.latest_price
        }
      end
    end
  end
  
  # GET /currencies/:id
  def show
    @price_snapshots = @currency.price_snapshots.recent.page(params[:page]).per(20)
  end
  
  # POST /currencies/capture_prices
  def capture_prices
    begin
      results = PriceCaptureService.capture_all
      
      if results[:errors].any?
        flash[:warning] = "Captured prices for #{results[:success].join(', ')}. Errors: #{results[:errors].map { |e| "#{e[:symbol]}: #{e[:error]}" }.join(', ')}"
      else
        flash[:notice] = "Successfully captured prices for all currencies"
      end
      
      # Clear relevant caches
      Rails.cache.delete('currencies_with_latest_prices')
      Currency.find_each do |currency|
        Rails.cache.delete_matched(["currency", currency.id, "snapshots", "*"])
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
    redirect_to currencies_path
  end
end
