class UpdateTaskTransaction
  include Dry::Transaction

  step :normalize
  step :permissions
  step :persist
  map :notify

  def normalize(input)
    Success(input.symbolize_keys)
  end

  def permissions(input)
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

  def notify(input)
    if input[:task].was_just_completed?
      Notifier.notify_watchers(input[:task])
    end
  end
end
