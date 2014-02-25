class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.string   :name
      t.datetime :start_time
      t.datetime :end_time
      t.string   :time_zone

      t.timestamps
    end
  end
end
