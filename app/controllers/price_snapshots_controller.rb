class PriceSnapshotsController < ApplicationController
  # GET /price_snapshots
  def index
    @price_snapshots = PriceSnapshot.includes(:currency)
                                   .recent
                                   .page(params[:page])
                                   .per(25)
  end
end
