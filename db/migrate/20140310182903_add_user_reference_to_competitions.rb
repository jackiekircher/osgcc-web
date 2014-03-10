class AddUserReferenceToCompetitions < ActiveRecord::Migration
  def change
    add_reference :competitions, :organizer, :index => true
  end
end
