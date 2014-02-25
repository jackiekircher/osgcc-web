class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string     :name
      t.belongs_to :competition

      t.timestamps
    end

    create_table :teams_users, id: false do |t|
      t.belongs_to :team
      t.belongs_to :user
    end
  end
end
