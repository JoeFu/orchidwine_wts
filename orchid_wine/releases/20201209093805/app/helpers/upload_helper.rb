module UploadHelper
  def upload_image(params_key)
  	return if (file = params[params_key]).blank?

    ext = file.original_filename.split('.').last.downcase
    return if !['jpg','png'].include?(ext)

    file_content = file.read
    md5 = Digest::MD5.hexdigest(file_content)
  	filename = "#{md5.downcase.to_s}.#{ext}"
    full_path = File.join(Const::UPLOAD_IMAGE, filename)

    if !File.exist? full_path
  	  File.open(full_path, 'wb') do |f|
  	    f.write(file_content)
  	  end
  	end

    Const.relative_path(full_path)
  end

  def upload_attachment(params_key)
    return if (file = params[params_key]).blank?
    full_path = File.join(Const::UPLOAD_ATTACHMENT, file.original_filename)
    file_content = file.read

    if !File.exist? full_path
      File.open(full_path, 'wb') do |f|
        f.write(file_content)
      end
    end

    result = {
      :full_path => Const.relative_path(full_path),
      :name => file.original_filename
    }
    attachment = Attachment.create :name => result[:name], :path => result[:full_path]
    result.merge(:id => attachment.id)
  end

  def upload_video(params_key)
    return if (file = params[params_key]).blank?
    ext = file.original_filename.split('.').last.downcase
    filename = ['video_', Time.now.strftime('%y%m%d%H%M%S'), '.', ext].join
    full_path = File.join(Const::UPLOAD_VIDEO, filename)
    file_content = file.read

    if !File.exist? full_path
      File.open(full_path, 'wb') do |f|
        f.write(file_content)
      end
    end

    result = {
      :url => Const.relative_path(full_path),
      :name => filename,
      :type => file.content_type
    }
  end


  def upload_file(params_key)
    return if (file = params[params_key]).blank?
    full_path = File.join(Const::UPLOAD_ATTACHMENT, file.original_filename)
    file_content = file.read

    if !File.exist? full_path
      File.open(full_path, 'wb') do |f|
        f.write(file_content)
      end
    end

    result = {
      :url => Const.relative_path(full_path),
      :name => file.original_filename,
      :size => File.size(full_path)
    }
  end
end