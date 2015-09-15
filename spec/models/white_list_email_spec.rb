require 'rails_helper'

RSpec.describe WhiteListEmail, type: :model do

  describe '#in_whitelist?' do
    it 'returns always true if env is not production' do
      expect(Rails).to receive(:env).and_return('development')

      expect(described_class.in_whiteList?('any string')).to eql true
    end
  end
end
