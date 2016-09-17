class Administrator < ApplicationRecord
  include Utils::Searching
  devise :database_authenticatable, :registerable, :trackable, :validatable, :lockable

  has_and_belongs_to_many :roles

  validates :name, presence: true

  searching :name, :email

  scope :can, -> (permission, model) {
    model = model.try(:name) || model.try(:constantize).try(:name)

    if model.present? && permission.present?
      left_outer_joins(roles: :permissions)
      .distinct
      .where("roles.full_control = 't' OR (:permission = ANY (permissions.actions) AND permissions.subject = :model)",
        permission: permission,
        model: model)
    end
  }

  def destroy
    self.main? ? false : super
  end
end
