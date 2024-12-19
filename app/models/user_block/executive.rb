# frozen_string_literal: true
module UserBlock
  class Executive < User
    has_many :allocation_drafts, foreign_key: :executive_id
  end
end
