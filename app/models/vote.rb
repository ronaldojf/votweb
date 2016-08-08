class Vote < ApplicationRecord
  acts_as_paranoid

  belongs_to :project
  belongs_to :councillor
  belongs_to :plenary_session

  validates :project, :councillor, :plenary_session, presence: true

  def destroy
    false
  end
end
