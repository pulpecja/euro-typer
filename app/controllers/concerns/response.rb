module Response
  def json_response(serializer, object)
    if object == :not_found || object == :unprocessable_entity
      return render json: { message: object }, status: object
    end
    render json: serializer.new(object)
  end
end