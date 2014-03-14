require 'spec_helper'

describe Spree::ImportPromotion do
  let(:reporter){ Spree::ImportPromotionInfo.create }

  context '#create' do
    let(:data) do
      {
       name: 'test',
       starts_at: '31/12/2012',
       expires_at: '31/12/2013',
       code: '12345',
       usage_limit: 10,
       amount: 100,
       description: 'description test',
       reporter_id: reporter.id,
       is_gift_card: 'Si',
       activation_expires_at: '31/12/2013'
      }
    end
    let(:import_promotion){ described_class.create(data) }
    let(:promotion){ import_promotion.promotion }

    it 'sets promotion name' do
      expect(promotion.name).to eq data[:name]
    end

    it 'sets promotion starts_at' do
      expect(promotion.starts_at).to eq data[:starts_at]
    end

    it 'sets promotion expires_at' do
      expect(promotion.expires_at).to eq data[:expires_at]
    end

    it 'sets promotion code' do
      expect(promotion.code).to eq data[:code]
    end

    it 'sets promotion usage_limit' do
      expect(promotion.usage_limit).to eq data[:usage_limit] + 1
    end

    it 'sets promotion description' do
      expect(promotion.description).to eq data[:description]
    end

    it 'sets promotion amount' do
      expect(promotion.actions.last.calculator.preferred_amount).to eq data[:amount]
    end

    it 'sets promotion default event name' do
      expect(promotion.event_name).to eq 'spree.checkout.coupon_code_added'
    end

    it 'sets promotion is_gift_card' do
      expect(promotion.is_gift_card).to be_true
    end

    it 'sets promotion activation_expires_at' do
      expect(promotion.activation_expires_at).to eq data[:activation_expires_at]
    end
  end

  context '#correct_dates_format' do
    let(:data) do
      {
       name: 'test',
       starts_at: '31/99/2012',
       expires_at: '99/12/2013',
       code: '12345',
       usage_limit: 10,
       amount: 100,
       description: 'description test',
       reporter_id: reporter.id
      }
    end

    let(:import_promotion){ described_class.create(data) }
    let(:promotion){ import_promotion.promotion }

    it 'sets starts_at validation error' do
      expect(import_promotion.errors[:starts_at][0]).to eq 'Formato tiene que ser DD/MM/AAAA'
    end

    it 'sets expires_at validation error' do
      expect(import_promotion.errors[:expires_at][0]).to eq 'Formato tiene que ser DD/MM/AAAA'
    end
  end
end
