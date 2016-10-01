class RemoveLogoFromParties < ActiveRecord::Migration[5.0]
  def change
    remove_attachment :parties, :logo
  end
end
