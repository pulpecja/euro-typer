module Response
  def json_response(serializer, object, options = {})
    if serializer.is_a?(Hash)
      # deal with exception messages,
      # when serializer is a key (message) and object is value (status)
      render json: serializer, status: object
    else
      render json: serializer.new(object, options)
    end
  end
end