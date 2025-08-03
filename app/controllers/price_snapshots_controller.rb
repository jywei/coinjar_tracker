class PriceSnapshotsController < ApplicationController
  PRICES_SHOWN_PER_PAGE = 20
  
  def index
    @price_snapshots = 
      PriceSnapshot.includes(:currency)
                   .recent
                   .page(params[:page])
                   .per(PRICES_SHOWN_PER_PAGE)
  end
end
