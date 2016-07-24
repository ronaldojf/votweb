class Role < ApplicationRecord
  include Utils::Searching

  has_and_belongs_to_many :administrators
  has_many :permissions, dependent: :destroy
  accepts_nested_attributes_for :permissions

  validates :description, presence: true, uniqueness: { case_sensitive: false }

  searching :description

  scope :full_control, -> {
    where(full_control: true)
  }

  def destroy
    super unless self.full_control
  end

  def update(params)
    super(params) unless self.full_control
  end
end
