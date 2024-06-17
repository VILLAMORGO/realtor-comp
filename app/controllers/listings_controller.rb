class ListingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_agents, only: [:new, :edit, :create, :update]
  before_action :set_listing, only: [:edit, :update, :destroy]

  def index
    @listings = current_user.listings
  end

  def show
    @listing = current_user.listings.find(params[:id])
  end

  def new
    @listing = current_user.listings.new
  end

  def create
    @listing = current_user.listings.new(listing_params)
    set_listing_mls_number

    if @listing.save
      redirect_to listings_path, notice: 'Listing was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    set_listing_mls_number

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

  private

  def set_agents
    @agents = User.where(role: :agent).where.not(id: current_user.id)
  end

  def set_listing
    @listing = current_user.listings.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(:listing_amount, :listing_agent, :commission_split, :listing_mls_number)
  end

  def set_listing_mls_number
    agent = User.find(listing_params[:listing_agent])
    @listing.listing_mls_number = agent.mls_number
  end
end