RSpec.describe 'CalcDisbursement' do
  describe 'should calculate the values correctly' do
    it 'testing less than 50' do
      expect(CalcDisbursement.new(1000).calc).to eq(10)
    end

    it 'testing higher or equal than 50 and less than 300' do
      expect(CalcDisbursement.new(10000).calc).to eq(950)
    end

    it 'testing higher than 300' do
      expect(CalcDisbursement.new(100000).calc).to eq(8500)
    end
  end
end
