class PlenarySession < ApplicationRecord
  include Utils::Searching
  acts_as_paranoid

  has_many :polls
  has_many :queues, class_name: 'CouncillorsQueue'
  has_many :members, class_name: 'SessionMember'
  has_many :items, class_name: 'SessionItem'
  accepts_nested_attributes_for :members, allow_destroy: true

  enum kind: [:ordinary, :extraordinary, :solemn, :special]

  searching :title

  scope :not_test, -> { where.not(is_test: true) }

  scope :by_kind, -> (kind) {
    where(kind: kinds[kind]) if kind.present?
  }

  scope :by_test, -> (is_test) {
    where(is_test: is_test.to_s == 'true') if !is_test.nil? && is_test.to_s.present?
  }

  validates :title, :kind, :start_at, :end_at, presence: true
  validates :start_at, date: { allow_blank: true }
  validates :end_at, date: { after: :start_at, allow_blank: true }
end
