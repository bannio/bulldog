module VideoHelper
  def video_path(file)
    Rails.root.join('tmp', 'videos', file)
  end
end