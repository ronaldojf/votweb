module CountdownHelpers
  extend ActiveSupport::Concern

  included do
    def duration
      super.try(:seconds) || super
    end

    def countdown
      countdown = (self.created_at + self.duration).to_i - DateTime.current.to_i
      countdown > 0 ? countdown : 0
    end

    def stop_countdown
      countdown = self.countdown

      if countdown > 0
        self.duration -= countdown
        self.save(validate: false)
      end
    end

    def open?
      # 3 segundos de folga
      (self.created_at + self.duration + 3.seconds) >= DateTime.current
    end
  end
end
