class Race
  attr_reader :name

  def initialize(**params)
    @name = params[:name]
    validate!
  end

  private

  def validate!
    raise ArgumentError.new("name must be present") unless name
  end
end