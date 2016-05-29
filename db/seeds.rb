%w(Francja Czechy Islandia Belgia Walia Hiszpania Słowacja Niemcy Polska Anglia Szwajcaria Irlandia\ Północna Rumunia Austria
  Rosja Włochy Chorwacja Portugalia Albania Turcja Węgry Irlandia Szwecja Ukraina).each do |team|
  Team.find_or_create_by(name: team)
end
