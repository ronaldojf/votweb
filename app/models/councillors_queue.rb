class CouncillorsQueue < ApplicationRecord

  def add_to_queue(councillor)
    councillor_id = (councillor.try(:id) || councillor).to_i

    if councillor_id > 0 && self.councillors_ids.exclude?(councillor_id)
      self.councillors_ids << councillor_id
      self.save
    end
  end

  def councillors
    councillors_order_map = self.councillors_ids.map.with_index { |id, index| [id, index] }.to_h
    councillors = Councillor.where(id: self.councillors_ids).to_a
    councillors.sort { |first, second| councillors_order_map[first.id] <=> councillors_order_map[second.id] }
  end
end
