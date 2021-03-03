class Character
  attr_reader :name

  def initialize(**params)
    @name = params[:name]
    @race = params[:race]
    validate!
  end

  def human?
    return 'probably' if race.empty?
    race.any? { |race| race.name.casecmp('human').zero? }
  end

  private

  attr_reader :race

  def validate!
    raise ArgumentError.new("name must be present") unless name
    raise ArgumentError.new("race must be present") unless race
    raise TypeError.new("race must be collection") unless race.respond_to? :each
  end
end