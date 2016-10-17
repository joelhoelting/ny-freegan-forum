class CreateBoroughs < ActiveRecord::Migration
  def change
    create_table :boroughs do |t|
      t.string :name
    end
  end
end
