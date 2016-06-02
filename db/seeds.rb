francja           = Team.find_or_create_by(name: "Francja").id
czechy            = Team.find_or_create_by(name: "Czechy").id
islandia          = Team.find_or_create_by(name: "Islandia").id
belgia            = Team.find_or_create_by(name: "Belgia").id
walia             = Team.find_or_create_by(name: "Walia").id
hiszpania         = Team.find_or_create_by(name: "Hiszpania").id
slowacja          = Team.find_or_create_by(name: "Słowacja").id
niemcy            = Team.find_or_create_by(name: "Niemcy").id
polska            = Team.find_or_create_by(name: "Polska").id
anglia            = Team.find_or_create_by(name: "Anglia").id
szwajcaria        = Team.find_or_create_by(name: "Szwajcaria").id
irlandia_polnocna = Team.find_or_create_by(name: "Irlandia Północna").id
rumunia           = Team.find_or_create_by(name: "Rumunia").id
austria           = Team.find_or_create_by(name: "Austria").id
rosja             = Team.find_or_create_by(name: "Rosja").id
wlochy            = Team.find_or_create_by(name: "Włochy").id
chorwacja         = Team.find_or_create_by(name: "Chorwacja").id
portugalia        = Team.find_or_create_by(name: "Portugalia").id
albania           = Team.find_or_create_by(name: "Albania").id
turcja            = Team.find_or_create_by(name: "Turcja").id
wegry             = Team.find_or_create_by(name: "Węgry").id
irlandia          = Team.find_or_create_by(name: "Irlandia").id
szwecja           = Team.find_or_create_by(name: "Szwecja").id
ukraina           = Team.find_or_create_by(name: "Ukraina").id

first_round  = Round.find_or_create_by(name: "Kolejka 1")
second_round = Round.find_or_create_by(name: "Kolejka 2")
third_round  = Round.find_or_create_by(name: "Kolejka 3")

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