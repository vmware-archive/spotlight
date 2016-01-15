class Category < ClassyEnum::Base
  def fields
    {}
  end
end

class Category::CiWidget < Category
  def fields
    {
      server_type: [:travis_ci],
      server_url: nil,
      project_name: nil,
      auth_key: nil
    }
  end
end