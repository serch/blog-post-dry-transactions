class Container
  extend Dry::Container::Mixin

  namespace 'operations' do |ops|
    ops.register 'check_user_can_edit_task' do
      CheckUserCanEditTask.new
    end
  end
end
