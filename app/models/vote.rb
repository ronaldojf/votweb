class Vote < ApplicationRecord
  acts_as_paranoid

  belongs_to :session_item
  belongs_to :councillor
  belongs_to :plenary_session

  validates :session_item, :councillor, :plenary_session, presence: true

  def destroy
    false
  end
end
