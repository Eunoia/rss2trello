Post = Struct.new(:title, :content, :posted_at)

class FeedsController < ApplicationController
  include ActionView::Helpers::DateHelper
  before_action :set_feed, only: [:show, :edit, :update, :destroy, :freshen]

  # GET /feeds
  # GET /feeds.json
  def index
    @feeds = current_user.feeds.all
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
  end

  # GET /feeds/new
  def new
    @feed = Feed.new
    Trello.configure do |config|
      config.developer_public_key = "85ed83dd4e226fd8fe5254352a698552"
      config.member_token = "19e8e277c01dc257f8feca3b0ae664f2a7a91914cde0a4aab7d81498334bc18f"
    end
  end

  # GET /feeds/1/edit
  def edit
  end

  # POST /feeds
  # POST /feeds.json
  def create
    @feed = Feed.new(feed_params)
    @feed.user = current_user
    @feed.last_retrived = Time.now
    respond_to do |format|
      if @feed.save
        format.html { redirect_to @feed, notice: 'Feed was successfully created.' }
        format.json { render :show, status: :created, location: @feed }
      else
        format.html { render :new }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feeds/1
  # PATCH/PUT /feeds/1.json
  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
        format.json { render :show, status: :ok, location: @feed }
      else
        format.html { render :edit }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed.destroy
    respond_to do |format|
      format.html { redirect_to feeds_url, notice: 'Feed was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def freshen
    @items = @feed.push_to_trello
    # redirect_to @feed
  end

  def fake_feed

    @posts = (1..10).to_a.map do |i|
      time = (5*i).minutes.ago
      p = Post.new(i ,distance_of_time_in_words_to_now(time),  time)
    end
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feed_params
      params.require(:feed).permit(:name, :url, :interval, :description, :last_retrived, :list_id)
    end
end
