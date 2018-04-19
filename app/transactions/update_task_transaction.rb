class UpdateTaskTransaction
  include Dry::Transaction

  step :normalize
  step :authorize
  step :persist

  def normalize(input)
    Success(input.symbolize_keys)
  end

  def authorize(input)
    if input[:user].can_edit?(input[:task])
      Success(input)
    else
      Failure(:cannot_edit)
    end
  end

  def persist(input)
    input[:task].update(input[:params])

    Success(input)
  end
end
