class UpdateTaskTransactionV2
  include Dry::Transaction(container: Container)

  step :normalize
  step :authorize, with: 'operations.check_user_can_edit_task'
  step :persist

  def normalize(input)
    Success(input.symbolize_keys)
  end

  def persist(input)
    input[:task].update(input[:params])

    Success(input)
  end
end
