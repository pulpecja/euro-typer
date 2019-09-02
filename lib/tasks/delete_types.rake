namespace :types do
  desc "Remove old types"
  task remove_types: :environment do
    ms = Competition.find(2)

    ms.rounds.map(&:id).each do |round_id|
      Round.find(round_id).matches.each do |match|
        match.types.destroy_all
      end
    end
  end
end
