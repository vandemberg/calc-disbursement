class CalcDisbursement
  def initialize(amount)
    @amount = amount
  end

  def calc
    return @amount * 0.01 if @amount < 5000
    return @amount * 0.095 if @amount >= 5000 and @amount <= 30000

    @amount * 0.085
  end
end
