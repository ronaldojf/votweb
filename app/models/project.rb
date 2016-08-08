class Project < ApplicationRecord
  include Utils::Searching
  acts_as_paranoid

  belongs_to :author, class_name: 'Councillor', foreign_key: :councillor_id

  searching :title

  validates :title, :author, presence: true
end
