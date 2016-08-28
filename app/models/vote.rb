class Vote < ApplicationRecord
  acts_as_paranoid

  belongs_to :councillor
  belongs_to :poll

  enum kind: [:approvation, :rejection, :abstention]

  validates :poll, :kind, presence: true
end
