class CreateStats < ActiveRecord::Migration
  def change
    create_table :headspace_stats do |t|
      t.integer :number_of_minutes
      t.integer :current_run_streak
      t.integer :longest_run_streak
      t.integer :num_sessions
      t.integer :avg_session_length
      t.string :display_name
      t.string :last_name
      t.string :remote_user_id, index: true
      t.string :first_name
      t.string :last_meditated, index: true
      t.timestamps null: false
    end
  end
end
