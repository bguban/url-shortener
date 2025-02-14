class UrlsController < ApplicationController
  def follow
    target = UrlFollower.new(params[:slug]).call
    if target
      redirect_to target, allow_other_host: true
    else
      head(:not_found)
    end
  end

  def index
    urls = Url.all

    render json: { urls: urls }
  end

  # GET /urls/1
  def show
    render json: { url: UrlDetailsSerializer.new(url) }
  end

  # POST /urls
  def create
    @url = Url.new(url_params)

    if @url.save
      render json: { url: @url }, status: :created, location: @url
    else
      render json: { errors: @url.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /urls/1
  def update
    if url.update(url_params)
      render json: { url: @url }
    else
      render json: { errors: @url.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /urls/1
  def destroy
    url.destroy!
  end

  private

  def url
    @url ||= Url.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def url_params
    params.require(:url).permit(:slug, :target)
  end
end
