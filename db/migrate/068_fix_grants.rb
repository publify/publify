class FixGrants < ActiveRecord::Migration
  def self.up
    say_with_time "Renaming ProfilesToRight to ProfilesRight" do
      rename_table :profiles_to_rights, :profiles_rights
    end
  end

  def self.down
    rename_table :profiles_rights, :profiles_to_rights
  end
end


