class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = %i[admin registered guest]

  has_many :types
  has_many :groups_users, dependent: :destroy
  has_many :groups, -> { distinct }, through: :groups_users

  validates :username, presence: true, uniqueness: true

  before_create :set_default_role

  scope :existing,    -> { where(deleted_at: nil).order(:username) }
  scope :deleted,     -> { where('deleted_at is not null').order(:username) }

  def is_admin?
    role == "admin"
  end

  def is_registered?
    role == "registered"
  end

  def user_competitions
    groups.map(&:competitions).flatten.uniq
  end

  def points(round= nil)
    points = 0

    unless types.nil?
      round_types = set_types(round, types)

      round_types.each do |type|
        match = type.match
        if match.bet.present? && type.bet == match.bet
          points += 1
          points += 1 if type.first_score == match.first_score && type.second_score == match.second_score
        end
      end
    end
    points
  end

  def set_types(round, types)
    if round.present?
      types.joins(:match).where('matches.round_id = ?', round.id)
    else
      types
    end

  end

  private
  def set_default_role
    self.role ||= "registered"
  end

end