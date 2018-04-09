namespace :competitions do
  desc "Add Euro 2016 competition"
  task :add_euro => :environment do
    competition = Competition.find_or_create_by(name: 'Mistrzostwa Europy',
                                                year: 2016,
                                                place: 'Francja')

    Round.where('started_at < ?', DateTime.now).each do |round|
      round.competition = competition
      round.save
    end
  end
end