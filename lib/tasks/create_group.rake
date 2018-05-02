namespace :groups do
  desc "Move users to group"
  task :create_first_group => :environment do
    group = Group.create(name: 'Kraków',
                         owner: User.find_by(username: 'pulpecja'))

    group.users << User.existing.where(take_part: true)
  end
end