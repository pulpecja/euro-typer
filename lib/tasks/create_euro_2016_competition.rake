namespace :competitions do
  desc "Add Euro 2016 competition"
  task :add_euro => :environment do
    competition = Competition.find_or_create_by(name: 'Mistrzostwa Europy',
                                                year: 2016,
                                                place: 'Francja')

    Round.where('created_at < ?', DateTime.now - 1.year)
         .order(:started_at)
         .each_with_index do |round, index|

      round.competition = competition
      round.stage = index + 1
      round.save
    end
  end
end