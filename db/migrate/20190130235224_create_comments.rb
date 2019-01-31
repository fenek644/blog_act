class CreateComments < ActiveRecord::Migration[5.2]
  def change

    create_table :clients do |t|
      t.text :content
      t.integer :post_id

      t.timestamps
    end

  end
end
