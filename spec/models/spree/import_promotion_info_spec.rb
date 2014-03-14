require 'spec_helper'

describe Spree::ImportPromotionInfo do
  let(:subject){ described_class.create }

  context '#report' do
    context 'with a valid record' do
      let(:data) do
        {
          name: 'test',
          starts_at: Date.today,
          expires_at: Date.today + 1.day,
          code: '12345',
          usage_limit: 10,
          amount: 100,
          description: 'description test',
          reporter_id: subject.id,
          promotion: create(:promotion)
        }
      end

      let(:import_promotion){ Spree::ImportPromotion.new(data) }

      it 'import_promotion_new incremets by 1' do
        subject.report(import_promotion)
        expect(subject.import_promotion_new.size).to eq 1
      end
    end

    context 'with a record with errors' do
      let(:data) do
        {
          starts_at: Date.today,
          expires_at: Date.today + 1.day,
          code: '12345',
          amount: 100,
          description: 'description test',
          reporter_id: subject.id,
          promotion: create(:promotion)
        }
      end

      let(:import_promotion){ Spree::ImportPromotion.new(data) }

      it 'import_promotion_errors incremets by 1' do
        import_promotion.save

        subject.report(import_promotion)
        expect(subject.import_promotion_errors.size).to eq 1
      end
    end

    context 'with an updated record' do
      let(:promotion){ create :promotion, code: '12345' }

      let(:data) do
        {
          name: 'test',
          starts_at: Date.today,
          expires_at: Date.today + 1.day,
          code: '12345',
          usage_limit: 10,
          amount: 100,
          description: 'description test',
          reporter_id: subject.id,
          promotion: promotion
        }
      end

      before do
        promotion.stub(:created_at){ 1.day.ago }
      end

      let(:import_promotion){ Spree::ImportPromotion.new(data) }

      it 'import_promotion_errors incremets by 1' do
        subject.report(import_promotion)

        expect(subject.import_promotion_updated.size).to eq 1
      end
    end
  end
end
