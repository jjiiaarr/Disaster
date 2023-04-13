# app/models/post.rb

class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :random_number, use: :slugged

  validates :title, presence: true
  validates :content, presence: true
  validates :address, presence: true

  has_many :comments
  has_many :post_category_ships
  has_many :categories, through: :post_category_ships

  belongs_to :user
  mount_uploader :image, ImageUploader

  def random_number
    rand(10_000).to_s.rjust(4,'0')
  end
end