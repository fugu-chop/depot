module InvalidObject

  private

  def invalid_object
    logger.error "Attempt to access invalid #{controller_name} #{params[:id]}"
    redirect_to store_index_url, notice: "Invalid #{controller_name}"
  end
end