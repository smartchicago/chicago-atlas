class AddPurpleBinderUrlAndProgramUrl < ActiveRecord::Migration
  def change
    add_column :intervention_locations, :purple_binder_url, :string, :default => ""
    add_column :intervention_locations, :program_url, :string, :default => ""
  end
end
