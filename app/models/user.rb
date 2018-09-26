class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = %i[admin registered guest]

  has_many :types
  has_many :groups_users, dependent: :destroy
  has_many :groups, -> { distinct }, through: :groups_users
  has_many :competitions_users, dependent: :destroy
  has_many :competitions, -> { distinct }, through: :competitions_users

  validates :username, presence: true, uniqueness: true

  before_create :set_default_role

  scope :existing,    -> { where(deleted_at: nil).order(:username) }
  scope :deleted,     -> { where('deleted_at is not null').order(:username) }
  scope :by_competition,->(competition) { select{ |u| u.competitions.include?(competition) } }

  def is_admin?
    role == "admin"
  end

  def is_registered?
    role == "registered"
  end

  def user_competitions
    groups.includes(:competitions).map(&:competitions).flatten.uniq
  end

  def type_points(round= nil, competition = nil)
    points = 0
    return 0 if types.nil?

    round_types = set_types(round, types, competition)

    round_types.includes(:match).each do |type|
      match = type.match
      if match.bet.present? && type.bet == match.bet
        points += 1
      end
    end

    points
  end

  def score_points(round= nil, competition = nil)
    points = 0
    return 0 if types.nil?

    round_types = set_types(round, types, competition)

    round_types.includes(:match).each do |type|
      match = type.match
      if match.bet.present? && type.bet == match.bet
        points += 1 if type.first_score == match.first_score && type.second_score == match.second_score
      end
    end

    points
  end

  def winner_points(competition)
    if competition.winner.present? &&
       competition.winner == WinnerType.find_by(user: self, competition: competition)&.team
      5
    else
      0
    end
  end

  def points(round= nil, competition = nil)
    type_points(round, competition) * 2 +
    score_points(round, competition)
  end

  def all_points(round= nil, competition = nil)
    points(round, competition) +
    winner_points(competition)
  end

  def set_types(round, types, competition=nil)
    if round.present?
      types.joins(:match).where('matches.round_id = ?', round.id)
    elsif competition.present?
      round_ids = competition.rounds.map(&:id)
      types.joins(:match).where('matches.round_id in (?)', round_ids)
    else
      types
    end
  end

  def winner_type_team(competition, user)
    type = WinnerType.find_by(competition: competition, user: self)&.team&.name
    return '?' if Time.now.in_time_zone < competition.start_date && type.present? && self != user
    type
  end

  private
  def set_default_role
    self.role ||= "registered"
  end

end