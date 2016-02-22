class Api::ComicsController < Api::BaseController
  def random
    xkcd_title, xkcd_img = XKCD.img.split(' : ')
    render json: {img_url: xkcd_img, img_title: xkcd_title}
  end
end
