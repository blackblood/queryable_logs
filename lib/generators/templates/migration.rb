class CreateTrailLogs < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :trail_logs do |t|
      t.integer :user_id
      t.string :ip_address
      t.string :controller
      t.string :action
      t.string :format
      t.string :http_verb
      t.json :params_hash
      t.datetime :logged_at
      t.string :response_code
      t.string :request_url
      t.string :sig

      t.index :sig, unique: true
      t.index :controller
      t.index :action
      t.timestamps null: false
    end
  end
end