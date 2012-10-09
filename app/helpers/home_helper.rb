module HomeHelper
  def send_notification friend
    @friend = friend
    render "/home/send_notification"
  end
end
