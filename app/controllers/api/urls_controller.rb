class Api::UrlsController < Api::BaseController
  after_action :allow_iframe, only: :url_content_copy
  def url
    render json: {
      url: "http://#{request.host_with_port}/api/url_content_copy/#{params[:id]}.html"
    }
  end

  def url_content_copy
    @widget ||= Widget.find_by_uuid(params[:id])
    respond_to do |format|
      format.html { render :text => URI.parse(@widget.url).read }
    end
  end

  private

   def allow_iframe
      response.headers['X-Frame-Options'] = 'ALLOW-FROM ' + ENV['WEB_HOST']
   end
end
