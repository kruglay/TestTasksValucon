class RemoveTimestepsFromRecord < ActiveRecord::Migration
  def change
    remove_timestamps Record
  end
end
