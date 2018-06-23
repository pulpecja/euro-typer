module GroupsHelper
  def set_place(rank, player_no, i, index)
    return place = rank + (player_no - i) if index != 0
    place = rank
  end
end