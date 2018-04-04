require 'dry/transaction/operation'

class NotifyWatchers
  include Dry::Transaction::Operation

  def call(input)
    if input[:task].was_just_completed?
      Notifier.notify_watchers(input[:task])
    end
  end
end
