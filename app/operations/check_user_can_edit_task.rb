require 'dry/transaction/operation'

class CheckUserCanEditTask
  include Dry::Transaction::Operation

  def call(input)
    if input[:user].can_edit?(input[:task])
      Success(input)
    else
      Failure(:cannot_edit)
    end
  end
end
