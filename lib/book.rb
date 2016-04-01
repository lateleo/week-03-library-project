require "active_record"

class Book < ActiveRecord::Base
# three attributes: title, author and ISBN, the latter of which is unique.
  validates :title, presence: true
  validates :author, presence: true
  validates :isbn, uniqueness: true
  validates :branch_id, presence: true
  belongs_to :branch
  belongs_to :patron
end
