class GroupService
  attr_reader :group

  def initialize(p = {}, group)
    @group = group
    @competition_ids = p[:competition_ids]
  end

  def add_competitions
    @group.competitions = []
    @competition_ids&.reject(&:empty?)&.each do |competition_id|
      @group.competitions << Competition.find(competition_id)
    end
  end
end