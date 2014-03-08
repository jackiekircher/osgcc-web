class AddDescriptionToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :description, :text
  end
end
