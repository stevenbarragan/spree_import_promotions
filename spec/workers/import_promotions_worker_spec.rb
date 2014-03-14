require 'spec_helper'

describe ImportPromotionsWorker do
  context '#perform' do
    let(:file_path) { SpreeImportPromotions::Engine.root.join('spec', 'fixtures', 'import_promotion.csv') }

    before do
      subject.perform(file_path)
    end

    it 'creates a new promotion' do
      expect(Spree::Promotion.count).to eq 2
    end
  end
end
