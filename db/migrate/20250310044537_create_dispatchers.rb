class CreateDispatchers < ActiveRecord::Migration[8.0]
  def change
    create_table :dispatchers do |t|
      t.string :name

      t.timestamps
    end
  end
end
