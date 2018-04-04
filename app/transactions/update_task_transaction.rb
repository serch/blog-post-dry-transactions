# require 'dry/transaction'

class UpdateTaskTransaction
  include Dry::Transaction

  step :process
  step :validate
  step :persist

  def process(input)
    Success(user: input[:user], task: input[:task], params: input[:params])
  end

  def validate(input)
    if input[:user].can_edit?(input[:task])
      Success(input)
    else
      Failure(:cannot_edit)
    end
  end

  def persist(input)
    input[:task].update(input[:params])

    Success(input[:task])
  end
end
