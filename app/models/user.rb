class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = %i[admin registered guest]

  has_many :types

  validates_presence_of :username

  before_create :set_default_role

  def is_admin?
    role == "admin"
  end

  def is_registered?
    role == "registered"
  end

  def points
    points = 0
    types.each do |type|
      match = type.match
      if match.bet.present? && type.bet == match.bet
        points +=1
        points += 1 if type.first_score == match.first_score && type.second_score == match.second_score
      end
    end
    points
  end

  private
  def set_default_role
    self.role ||= "registered"
  end

end