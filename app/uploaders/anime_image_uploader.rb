class AnimeImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog
  # 本番環境と開発・テスト環境で保存先を分ける
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  #   # For Rails 3.1+ asset pipeline compatibility:
  def default_url(*args)
    ActionController::Base.helpers.asset_path("default_anime_image.jpg")
  end
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_allowlist
    %w[jpg jpeg gif png webp]
  end
end
