class Container
  extend Dry::Container::Mixin

  namespace 'operations' do |ops|
    ops.register 'check_user_can_edit_task' do
      CheckUserCanEditTask.new
    end

    ops.register 'notify_watchers' do
      NotifyWatchers.new
    end
  end
end
