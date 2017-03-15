class PlenarySession < ApplicationRecord
  include Utils::Searching
  acts_as_paranoid

  has_many :polls
  has_many :queues, class_name: 'CouncillorsQueue'
  has_many :members, class_name: 'SessionMember'
  has_many :items, class_name: 'SessionItem'
  has_many :countdowns
  has_many :subscriptions
  accepts_nested_attributes_for :members, allow_destroy: true
  accepts_nested_attributes_for :items

  enum kind: [:ordinary, :extraordinary, :solemn, :special]

  searching :title

  scope :not_test, -> { where.not(is_test: true) }

  scope :starts_today_or_yesterday, -> {
      where('plenary_sessions.start_at BETWEEN :start AND :end', start: 1.day.ago.at_beginning_of_day, end: Time.zone.now.at_end_of_day)
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

  def check_members_attendance
    attendance_queue_base = self.queues.attendance.where(override_attendance: true).order(created_at: :desc).first
    present_councillors_ids = attendance_queue_base.present? ? attendance_queue_base.councillors_ids : self.members.map { |member| member.councillor_id }

    self.queues.attendance
        .where(":start IS NULL OR councillors_queues.created_at > :start", start: attendance_queue_base.try(:created_at))
        .each do |queue|

      present_councillors_ids.select! { |id| queue.councillors_ids.include?(id) }
    end

    self.polls
        .where.not(process: Poll.processes[:secret])
        .where(":start IS NULL OR polls.created_at > :start", start: attendance_queue_base.try(:created_at))
        .includes(:votes)
        .each do |poll|

      councillor_ids = poll.votes.map { |vote| vote.councillor_id }
      present_councillors_ids.select! { |id| councillor_ids.include?(id) }
    end

    PlenarySession.transaction do
      self.members.each do |member|
        member.is_present = member.is_president ? true : present_councillors_ids.include?(member.councillor_id)
        member.save(validate: false)
      end
    end
  end
end
