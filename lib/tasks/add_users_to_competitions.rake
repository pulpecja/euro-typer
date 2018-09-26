namespace :users do
  desc "Fix teams"
  task :add_to_competitions => :environment do
    Group.all.each do |group|
      group.competitions.each do |competition|
        group.users.each do |user|
          next if user.all_points(nil, competition) == 0
          user.competitions << competition
          user.save
        end
      end
    end
  end
end