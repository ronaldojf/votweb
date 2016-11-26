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

  scope :starts_today, -> {
    where('plenary_sessions.start_at BETWEEN :start AND :end', start: DateTime.current.at_beginning_of_day, end: DateTime.current.at_end_of_day)
  }

  scope :has_member, -> (councillor) {
    councillor_id = councillor.try(:id) || councillor
    where(
      "(SELECT true FROM session_members WHERE session_members.plenary_session_id = plenary_sessions.id AND session_members.councillor_id = :councillor_id LIMIT 1)",
      councillor_id: councillor_id
    )
  }

  scope :by_kind, -> (kind) {
    where(kind: kinds[kind]) if kind.present?
  }

  scope :by_test, -> (is_test) {
    where(is_test: is_test.to_s == 'true') if !is_test.nil? && is_test.to_s.present?
  }

  validates :title, :kind, :start_at, presence: true
  validates :start_at, date: { allow_blank: true }

  def check_members_presence
    present_councillors_ids = self.members.map { |member| member.councillor_id }.uniq

    self.polls.includes(:votes).each do |poll|
      unless poll.secret?
        councillor_ids = poll.votes.map { |vote| vote.councillor_id }
        present_councillors_ids.select! { |id| councillor_ids.include?(id) }
      end
    end

    PlenarySession.transaction do
      self.members.each do |member|
        if member.is_president
          member.is_present = true
        else
          member.is_present = present_councillors_ids.include?(member.councillor_id)
        end

        member.save(validate: false)
      end
    end
  end
end
