class CreateTools < ActiveRecord::Migration[6.1]
  def change
    create_table :tools do |t|
      t.string :name
      t.string :language, limit: 2
      t.json :json_spec

      t.timestamps
    end
  end
end
