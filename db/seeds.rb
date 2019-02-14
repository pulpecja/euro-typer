def create_country(name, abbr)
  Team.find_or_create_by(name: name, abbreviation: abbr)
end

albania           = create_country("Albania", "ALB").id
anglia            = create_country("Anglia", "ENG").id
austria           = create_country("Austria", "AUT").id
belgia            = create_country("Belgia", "BEL").id
chorwacja         = create_country("Chorwacja", "CRO").id
czechy            = create_country("Czechy", "CZE").id
francja           = create_country("Francja", "FRA").id
hiszpania         = create_country("Hiszpania", "ESP").id
irlandia          = create_country("Irlandia", "IRL").id
irlandia_polnocna = create_country("Irlandia Północna", "NIR").id
islandia          = create_country("Islandia", "ISL").id
niemcy            = create_country("Niemcy", "GER").id
polska            = create_country("Polska", "POL").id
portugalia        = create_country("Portugalia", "POR").id
rosja             = create_country("Rosja", "RUS").id
rumunia           = create_country("Rumunia", "ROU").id
slowacja          = create_country("Słowacja", "SVK").id
szwajcaria        = create_country("Szwajcaria", "SUI").id
szwecja           = create_country("Szwecja", "SWE").id
turcja            = create_country("Turcja", "TUR").id
ukraina           = create_country("Ukraina", "UKR").id
walia             = create_country("Walia", "WAL").id
wegry             = create_country("Węgry", "HUN").id
wlochy            = create_country("Włochy", "ITA").id

admin = User.where(username: 'admin', email: 'admin@typerek.com').first_or_create do |user|
  user.password = 'typerek1'
  user.role = 'admin'
end

user = User.where(username: 'registered_user', email: 'registered_user@typerek.com').first_or_create do |user|
  user.password = 'typerek1'
  user.role = 'registered'
end

competition = Competition.where(name: 'default_competition').first_or_create do |competition|
  competition.end_date = Date.today - 20.days
  competition.place = 'Pilczyca'
  competition.start_date = DateTime.now - 200.days
  competition.winner_id = Team.first.id
  competition.year = 2019
end

competition_2 = Competition.where(name: 'default_competition').first_or_create do |competition|
  competition.end_date = DateTime.now - 20.days
  competition.place = 'Pilczyca'
  competition.start_date = DateTime.now - 200.days
  competition.winner_id = Team.first.id
  competition.year = 2019
end

setting = Setting.where(name: 'default_competition').first_or_create do |setting|
  setting.value = competition.id
end

first_round = Round.where(name: "Kolejka 1").first_or_create do |round|
  round.competition_id = competition.id
  round.stage = 1
  round.started_at = DateTime.now - 30.days
end

second_round = Round.where(name: "Kolejka 2").first_or_create do |round|
  round.competition_id = competition.id
  round.stage = 2
  round.started_at = DateTime.now - 20.days
end

third_round = Round.where(name: "Kolejka 3").first_or_create do |round|
  round.competition_id = competition.id
  round.stage = 3
  round.started_at = DateTime.now - 10.days
end

[
  [francja,           rumunia,           "2016-06-10 21:00:00", first_round],
  [albania,           szwajcaria,        "2016-06-11 15:00:00", first_round],
  [walia,             slowacja,          "2016-06-11 18:00:00", first_round],
  [anglia,            rosja,             "2016-06-11 21:00:00", first_round],
  [turcja,            chorwacja,         "2016-06-12 15:00:00", first_round],
  [polska,            irlandia_polnocna, "2016-06-12 18:00:00", first_round],
  [niemcy,            ukraina,           "2016-06-12 21:00:00", first_round],
  [hiszpania,         czechy,            "2016-06-13 15:00:00", first_round],
  [irlandia,          szwecja,           "2016-06-13 18:00:00", first_round],
  [belgia,            wlochy,            "2016-06-13 21:00:00", first_round],
  [austria,           wegry,             "2016-06-14 18:00:00", first_round],
  [portugalia,        islandia,          "2016-06-14 21:00:00", first_round],
  [rosja,             slowacja,          "2016-06-15 15:00:00", second_round],
  [rumunia,           szwajcaria,        "2016-06-15 18:00:00", second_round],
  [francja,           albania,           "2016-06-15 21:00:00", second_round],
  [anglia,            walia,             "2016-06-16 15:00:00", second_round],
  [ukraina,           irlandia_polnocna, "2016-06-16 18:00:00", second_round],
  [niemcy,            polska,            "2016-06-16 21:00:00", second_round],
  [wlochy,            szwecja,           "2016-06-17 15:00:00", second_round],
  [czechy,            chorwacja,         "2016-06-17 18:00:00", second_round],
  [hiszpania,         turcja,            "2016-06-17 21:00:00", second_round],
  [belgia,            irlandia,          "2016-06-18 15:00:00", second_round],
  [islandia,          wegry,             "2016-06-18 18:00:00", second_round],
  [portugalia,        austria,           "2016-06-18 21:00:00", second_round],
  [rumunia,           albania,           "2016-06-19 21:00:00", third_round],
  [szwajcaria,        francja,           "2016-06-19 21:00:00", third_round],
  [rosja,             walia,             "2016-06-20 21:00:00", third_round],
  [slowacja,          anglia,            "2016-06-20 21:00:00", third_round],
  [ukraina,           polska,            "2016-06-21 18:00:00", third_round],
  [irlandia_polnocna, niemcy,            "2016-06-21 18:00:00", third_round],
  [czechy,            turcja,            "2016-06-21 21:00:00", third_round],
  [chorwacja,         hiszpania,         "2016-06-21 21:00:00", third_round],
  [wlochy,            irlandia,          "2016-06-22 21:00:00", third_round],
  [szwecja,           belgia,            "2016-06-22 21:00:00", third_round],
  [islandia,          austria,           "2016-06-22 18:00:00", third_round],
  [wegry,             portugalia,        "2016-06-22 18:00:00", third_round]
].each do |record|
  Match.find_or_create_by(first_team_id: record[0], second_team_id: record[1], played: record[2], round: record[3])
end
