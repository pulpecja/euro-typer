namespace :teams do
  desc "Add flags to teams"
  task :add_flags => :environment do

    [ ["Albania", 'Flag_of_Albania.svg'],
      ["Anglia", 'Flag_of_England.svg'],
      ["Austria", 'Flag_of_Austria.svg'],
      ["Belgia", 'Flag_of_Belgium.svg'],
      ["Chorwacja", 'Flag_of_Croatia.svg'],
      ["Czechy", 'Flag_of_the_Czech_Republic.svg'],
      ["Francja", 'Flag_of_France.svg'],
      ["Hiszpania", 'Flag_of_Spain.svg'],
      ["Irlandia", 'Flag_of_Ireland.svg'],
      ["Irlandia Północna", 'Flag_of_Northern_Ireland.svg'],
      ["Islandia", 'Flag_of_Iceland.svg'],
      ["Niemcy", 'Flag_of_Germany.svg'],
      ["Polska", 'Flag_of_Poland.svg'],
      ["Portugalia", 'Flag_of_Portugal.svg'],
      ["Rosja", 'Flag_of_Russia.svg'],
      ["Rumunia", 'Flag_of_Romania.svg'],
      ["Słowacja", 'Flag_of_Slovakia.svg'],
      ["Szwajcaria", 'Flag_of_Switzerland.svg'],
      ["Szwecja", 'Flag_of_Sweden.svg'],
      ["Turcja", 'Flag_of_Turkey.svg'],
      ["Ukraina", 'Flag_of_Ukraine.svg'],
      ["Walia", 'Flag_of_Wales_2.svg'],
      ["Węgry", 'Flag_of_Hungary.svg'],
      ["Włochy", 'Flag_of_Italy.svg']].each do |country, flag|
        Team.where(name: country).first.update_attribute(:flag, flag)
      end
    end
  end

