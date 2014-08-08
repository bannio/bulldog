module VideoHelper
  def video_path(file)
    # Rails.root.join('tmp', 'videos', file)
    path = "https://s3.amazonaws.com/" + ENV['S3_BUCKET_NAME'] + "/videos/" + file
  end
end