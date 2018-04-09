module CompetitionsHelper
  def competition_name
     "#{@competition.name} #{@competition.year.to_s}"
  end
end
