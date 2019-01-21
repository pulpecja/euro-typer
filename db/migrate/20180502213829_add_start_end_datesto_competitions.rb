class AddStartEndDatestoCompetitions < ActiveRecord::Migration[5.2]
  def change
    add_column :competitions, :start_date, :datetime
    add_column :competitions, :end_date, :datetime
  end
end
