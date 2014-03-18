class AddRepositoryUrlToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :repository_url, :string
  end
end
