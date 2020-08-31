class Book < ApplicationRecord
  enum sales_status: { reservation: 0, now_on_sale: 1, end_of_print: 2 }
  belongs_to :publisher
  has_many :book_authors
  has_many :authors, through: :book_authors
  scope :costly, -> { where('price > ?', 3000) }
  scope :written_about, -> (theme) { where('name like ?', "%#{theme}%") }
  validates :name, presence: true, length: { maximum: 25 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  # 独自のバリデーション
  validate do |book|
    if book.name.include?('exercise')
      book.errors[:name] << "I don't like exercise."
    end
  end
  # callbacks
  before_validation :add_lovely_to_cat
  after_destroy :leave_delete_log

  def add_lovely_to_cat
    self.name = self.name.gsub(/Cat/) do |matched|
      "lovely #{matched}"
    end
  end

  def leave_delete_log
    Rails.logger.info "Book is deleted: #{self.attributes}"
  end
end
