class BlacklistedToken < ApplicationRecord
    validates :token, presence: true, uniqueness: true
end  