class UpdateTaskTransactionWithOperations
  include Dry::Transaction(container: Container)

  step :normalize
  step :permissions, with: 'operations.check_user_can_edit_task'
  step :persist
  map :notify, with: 'operations.notify_watchers'

  def normalize(input)
    Success(input.symbolize_keys)
  end

  def persist(input)
    input[:task].update(input[:params])

    Success(input)
  end
end
