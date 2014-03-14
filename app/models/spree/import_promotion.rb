class Spree::ImportPromotion
  include Sidekiq::Worker
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :starts_at, :expires_at, :code, :usage_limit, :amount,
                :event_name, :description, :promotion, :reporter_id, :reporter,
                :line, :activation_expires_at, :is_gift_card

  validates :name, :code, :amount, :usage_limit, :reporter_id, presence: true
  validates :amount, numericality: true
  validate :correct_dates_format

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end

    @reporter = Spree::ImportPromotionInfo.find(reporter_id)
  end

  def self.create(attributes = {})
    import_promotion = new(attributes)
    import_promotion.save

    import_promotion.reporter.report(import_promotion)

    import_promotion
  end

  def save
    valid? ? set_promotion : false
  end

  private

  def correct_dates_format
    [:starts_at, :expires_at, :activation_expires_at].each{ |date| check_date(date) }
  end

  def check_date(field)
    begin
      date = send(field)
      Date.parse(date) if date
    rescue
      errors.add(field, 'Formato tiene que ser DD/MM/AAAA')
    end
  end

  def set_promotion
    @promotion = find_or_create_promotion
    @promotion.actions.destroy_all
    @promotion.actions << action
    @promotion
  end

  def promotion_data
    {
      name: name,
      starts_at: starts_at,
      expires_at: expires_at,
      code: code,
      #NOTE: +1 cause spree bug, you need to set 1 more of the usage limit you want
      usage_limit: usage_limit.to_i + 1,
      event_name: event_name ? event_name : 'spree.checkout.coupon_code_added',
      description: description,
      is_gift_card: is_gift_card.downcase == 'si' ? true : false,
      activation_expires_at: activation_expires_at
    }
  end

  def find_or_create_promotion
    promotion = Spree::Promotion.find_by_code(code)

    if promotion
      promotion.update_attributes(promotion_data)
    else
      promotion = Spree::Promotion.create(promotion_data)
    end

    promotion
  end

  def action
    calculator = Spree::Calculator::FlatRate.new
    calculator.set_preference :amount, amount

    action = Spree::Promotion::Actions::CreateAdjustment.new
    action.calculator = calculator
    action
  end
end
