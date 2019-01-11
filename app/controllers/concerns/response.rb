module Response
  def json_response(serializer, object)
    render json: serializer.new(object)
  end
end