class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  after_destroy :ensure_an_admin_remains
  has_secure_password

  class NoUsersError < StandardError 
  end

  class IncorrectPasswordError < StandardError 
  end

  private
    def ensure_an_admin_remains
      if User.count.zero?
        raise NoUsersError.new "Can't delete last user"
      end
    end
end
