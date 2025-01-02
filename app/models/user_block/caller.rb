# frozen_string_literal: true
module UserBlock
  class Caller < User
    has_many :allocation_drafts, foreign_key: :caller_id
  end
end
