require "active_record"
require_relative "staff_member.rb"
require_relative "book.rb"
require_relative "patron.rb"

class Branch < ActiveRecord::Base
# has three unique attributes: branch name, phone number, and address.
  validates :name, presence: true, uniqueness: true
  validates :address, presence: true, uniqueness: true
# the regexp below is incredibly messy. Here is what each part does:
# + \A requires that the 1st character of the string matches the first character of the pattern.
# + [2-9] requires the 1st digit of the area code to be a number that isn't 0 or 1.
# + (\d) ensures that the 2nd digit of the area code is a number, and establishes it
#   as a group that can be referenced later.
# + (?!\1) references the group created previously, and ensures that the character that follows
#   is not the same as the character in the group (IE, it makes sure that the 2nd and 3rd
#   digits in the area code are not the same).
# + \d- ensures that the 3rd digit is a number, and is followed by a hyphen.
# + [2-9]\d\d ensures that the central office code (the 3 digits after the area code)
#   is comprised of only numbers, and that the first isn't 0 or 1.
# + -\d{4} puts a hyphen after the central office code, and follows with 4 digits 0-9.
# + \Z requires that the last character of the string matches the last character of the pattern.
#   together with \A at the beginning, requires an exact number of characters.
  validates :phone_number, uniqueness: true, format: {with: /\A[2-9](\d)(?!\1)\d-[2-9]\d\d-\d{4}\Z/}
  before_validation :format_phone_number
  has_many :staff_members
  has_many :books

# This method is called before validation, and converts the phone_number to
# "xxx-xxx-xxxx" format if it is the proper length. Otherwise, it removes all non-numbers,
# as well as the first digit if it's a "1".
  def format_phone_number
    phone_number.delete!("^0-9")
    phone_number.slice!(0) if (phone_number[0] == "1" && phone_number.length > 10)
    [3,7].each {|n| phone_number.insert(n, "-")} if phone_number.length == 10
  end

end
