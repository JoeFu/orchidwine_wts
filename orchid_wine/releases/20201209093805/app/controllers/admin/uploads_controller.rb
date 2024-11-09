# [管理后台] 上传图片
include UploadHelper
class Admin::UploadsController < Admin::ApplicationController

	def image
		file_path = upload_image(:file)
	  return 'error' if file_path.blank?
		result = {
		  :success => true,
		  :file_path => file_path
		}
    render json: result
	end


	def attachment
		result = upload_attachment(:file)
		{:error => 'error'} if result.blank?
		result.merge!({:success => true})
    render json: result
	end


	def video
		result = upload_video(:file)
		{:error => 'error'} if result.blank?

		result.merge!({
			:success => true,
			:state => 'SUCCESS',
			})
    render json: result
	end


	def file
		result = upload_file(:file)
		{:error => 'error'} if result.blank?

		result.merge!({:success => true})
    render json: result
	end
end