module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.class.to_s, current_user.name
    end

    protected
      def find_verified_user
        verified_user = if cookies.signed[:administrator_id]
            Administrator.find_by(id: cookies.signed[:administrator_id])
          else
            Councillor.find_by(id: cookies.signed[:councillor_id])
          end

        if verified_user
          verified_user
        else
          reject_unauthorized_connection
        end
      end
  end
end
