class CreateUserStamps < ActiveRecord::Migration[7.0]
  def change
    create_table :user_stamps do |t|
      t.references :user, null: false, foreign_key: true
      t.references :stamp, null: false, foreign_key: true
      t.references :chore_history, null: false, foreign_key: true

      t.timestamps
    end
  end
end
