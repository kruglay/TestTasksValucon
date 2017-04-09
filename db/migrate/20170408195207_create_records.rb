class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :version
      t.string :gem_copy
      t.string :sha

      t.timestamps null: false
    end
  end
end
