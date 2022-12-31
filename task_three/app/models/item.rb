# frozen_string_literal: true

class Item < ApplicationRecord
  before_create  :set_position
  before_destroy :shift_position

  private

  def set_position
    self.position = if Item.last
                      (Item.last['position'] + 1)

                    else
                      1
                    end
  end

  def shift_position
    Item.where('position>?', position).each do |item|
      item.position = item.position - 1
      item.save
    end
  end
end
