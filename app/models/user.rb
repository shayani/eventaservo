# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable,
         :omniauthable, omniauth_providers: %i[facebook]

  has_one_attached :picture
  store_accessor :mailings, :weekly_summary
  store_accessor :instruo, :instruisto
  store_accessor :prelego, :preleganto
  store_accessor :ligiloj, [:youtube, :telegram, :instagram, :facebook, :vk]

  before_save :generate_username, if: :new_record?
  before_save :subscribe_mailings, if: :new_record?
  before_save :sanitize_links

  has_many :events
  belongs_to :country, inverse_of: :users
  has_many :organization_users
  has_many :organizations, through: :organization_users # TODO: Evitinda
  has_many :organizoj, through: :organization_users, source: :organization

  validates :name, presence: true
  validates :username, uniqueness: true

  scope :receives_weekly_summary, -> { where('mailings @> ?', { weekly_summary: '1' }.to_json) }
  scope :admins, -> { where(admin: true) }
  scope :instruistoj, -> { where("instruo ->> 'instruisto' = 'true'") }

  def self.from_omniauth(auth)
    if where(email: auth.info.email).exists?
      return_user          = find_by(email: auth.info.email)
      return_user.provider = auth.provider
      return_user.uid      = auth.uid
    else
      return_user =
        create! do |user|
          user.provider   = auth.provider
          user.uid        = auth.uid
          user.email      = auth.info.email || "nova_uzanto_#{rand(1000)}@eventaservo.org"
          user.password   = Devise.friendly_token[0, 20]
          user.name       = auth.info.name # assuming the user model has a name
          user.image      = auth.info.image # assuming the user model has an image
          user.country_id = 99999
          user.skip_confirmation!
        end
      NovaUzantoSciigoJob.perform_now(return_user)
    end
    return_user
  end

  def owner_of(record)
    record.user_id == id
  end

  def organiza_membro_de_evento(evento)
    id.in? evento.organizations.joins(:uzantoj).pluck(:user_id)
  end

  def follower?(record)
    !record.followers.find_by(user_id: self).nil?
  end

  def generate_username(random: false)
    return false if username.present?

    username = ActiveSupport::Inflector.transliterate(name).tr(' ', '_').tr('.', '_').downcase
    username += SecureRandom.rand(100).to_s if random

    if User.find_by(username: username)
      generate_username(random: true)
    else
      update_attribute(:username, username)
    end
  end

  # Kontrolas ĉu la uzanto estas administranto de organizo.
  #
  # @param [Object] organizo Organizo
  # @return [Boolean] se la uzanto estas administranto
  # @note Ĉiam respondas +true+ se la uzanto estas ES-Admin.
  def administranto?(organizo)
    (in? organizo.administrantoj) || admin
  end

  # Kontrolas ĉu la uzanto estas membro de organizo.
  #
  # @param [Object] organizo Organizo
  # @return [Boolean] se la uzanto estas administranto
  def membro?(organizo)
    (in? organizo.membroj)
  end

  # Kontras ĉu la uzanto havas ian publikan kontaktan informon
  #
  # @return [Boolean]
  # @since 2.15
  def havas_publikajn_kontaktojn?
    youtube.present? or telegram.present? or instagram.present?
  end

  private

    def subscribe_mailings
      self.weekly_summary = '1'
    end

    def sanitize_links
      return if ligiloj.keys.empty?

      ligiloj.keys.each do |site|
        next if site.empty?

        address = ligiloj[site]
        if address[%r{\Ahttp:\/\/}] || address[%r{\Ahttps:\/\/}]
          address.strip
        elsif address.strip.empty?
          nil
        else
          ligiloj[site] = "https://#{address.strip}"
        end
      end
    end
end
