class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :title
      t.string :business
      t.string :location
      t.text :content
      t.date :date
      t.integer :borough_id
      t.integer :user_id
      t.timestamps
    end
  end
end
