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

[
  [francja,           rumunia,           "2016-06-10 21:00:00"],
  [albania,           szwajcaria,        "2016-06-11 15:00:00"],
  [walia,             slowacja,          "2016-06-11 18:00:00"],
  [anglia,            rosja,             "2016-06-11 21:00:00"],
  [turcja,            chorwacja,         "2016-06-12 15:00:00"],
  [polska,            irlandia_polnocna, "2016-06-12 18:00:00"],
  [niemcy,            ukraina,           "2016-06-12 21:00:00"],
  [hiszpania,         czechy,            "2016-06-13 15:00:00"],
  [irlandia,          szwecja,           "2016-06-13 18:00:00"],
  [belgia,            wlochy,            "2016-06-13 21:00:00"],
  [austria,           wegry,             "2016-06-14 18:00:00"],
  [portugalia,        islandia,          "2016-06-14 21:00:00"],
  [rosja,             slowacja,          "2016-06-15 15:00:00"],
  [rumunia,           szwajcaria,        "2016-06-15 18:00:00"],
  [francja,           albania,           "2016-06-15 21:00:00"],
  [anglia,            walia,             "2016-06-16 15:00:00"],
  [ukraina,           irlandia_polnocna, "2016-06-16 18:00:00"],
  [niemcy,            polska,            "2016-06-16 21:00:00"],
  [wlochy,            szwecja,           "2016-06-17 15:00:00"],
  [czechy,            chorwacja,         "2016-06-17 18:00:00"],
  [hiszpania,         turcja,            "2016-06-17 21:00:00"],
  [belgia,            irlandia,          "2016-06-18 15:00:00"],
  [islandia,          wegry,             "2016-06-18 18:00:00"],
  [portugalia,        austria,           "2016-06-18 21:00:00"],
  [rumunia,           albania,           "2016-06-19 21:00:00"],
  [szwajcaria,        francja,           "2016-06-19 21:00:00"],
  [rosja,             walia,             "2016-06-20 21:00:00"],
  [slowacja,          anglia,            "2016-06-20 21:00:00"],
  [ukraina,           polska,            "2016-06-21 18:00:00"],
  [irlandia_polnocna, niemcy,            "2016-06-21 18:00:00"],
  [czechy,            turcja,            "2016-06-21 21:00:00"],
  [chorwacja,         hiszpania,         "2016-06-21 21:00:00"],
  [wlochy,            irlandia,          "2016-06-22 21:00:00"],
  [szwecja,           belgia,            "2016-06-22 21:00:00"],
  [islandia,          austria,           "2016-06-22 18:00:00"],
  [wegry,             portugalia,        "2016-06-22 18:00:00"]
].each do |record|
  Match.find_or_create_by(first_team_id: record[0], second_team_id: record[1], played: record[2])
end