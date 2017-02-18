class AddDefaultAbstractToSessionItems < ActiveRecord::Migration[5.0]
  def up
    SessionItem.update_all abstract: 'Sem ementa.'
  end

  def down
  end
end
