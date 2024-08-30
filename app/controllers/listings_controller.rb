class ListingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @q = Listing.includes(:user).ransack(params[:q])
    @per_page = (params[:per_page] || 10).to_i
    @page = params[:page] || 1

    # Fetch My Listings and All Listings separately with pagination
    @my_listings = current_user.listings.where(active: "true").paginate(page: @page, per_page: @per_page)
    @all_listings = @q.result.where(active: "true").paginate(page: @page, per_page: @per_page)

    respond_to do |format|
      format.html
      format.json {
        render json: {
          my_listings: @my_listings,
          all_listings: @all_listings,
          my_listings_pagination: {
            current_page: @my_listings.current_page,
            total_pages: @my_listings.total_pages,
            per_page: @my_listings.per_page,
            total_entries: @my_listings.total_entries
          },
          all_listings_pagination: {
            current_page: @all_listings.current_page,
            total_pages: @all_listings.total_pages,
            per_page: @all_listings.per_page,
            total_entries: @all_listings.total_entries
          }
        }
      }
    end
  rescue => e
    Rails.logger.error "Ransack search error: #{e.message}"
    flash[:alert] = "Error: #{e.message}"
    @my_listings = current_user.listings.none.paginate(page: @page, per_page: @per_page)
    @all_listings = Listing.none.paginate(page: @page, per_page: @per_page)
  end
  
  def show
  end

  def new
    @listing = current_user.listings.new
  end

  def create
    @listing = current_user.listings.new(listing_params)

    if @listing.save
      redirect_to listings_path, notice: 'Listing was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @listing.update(listing_params)
      redirect_to listings_path, notice: 'Listing was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @listing.destroy
    redirect_to listings_path, notice: 'Listing was successfully deleted.'
  end

  def toggle_active
    @listing = Listing.find(params[:id])
    @listing.update(active: !@listing.active)
    redirect_to listings_path, notice: "Listing status was successfully updated."
  end

  private

  def set_listing
    # @listing = current_user.listings.find(params[:id])
    @listing = Listing.all.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(:listing_commission_amount, :commission_split, :commission_type, :listing_mls_number, :notes, :active)
  end

  def authorize_user!
    unless current_user.admin? || current_user == @listing.user
      redirect_to listings_path, alert: "You are not authorized to perform this action."
    end
  end
end