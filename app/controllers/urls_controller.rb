class UrlsController < ApplicationController
  def follow
    url = Url.find_by(slug: params[:slug])
    if url
      Url.where(id: url.id).update_all('redirects_count = redirects_count + 1')
      redirect_to url.target, allow_other_host: true
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
    render json: { url: url }
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
