class AddPartyToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :party, :string
  end
end
