class Api::EmailsController < ApplicationController
  def track
    json = params['_json']
    unless json.nil?
      if json.class.to_s == "Array"
        json.each{ |i| update_msg_thread i['email'], i['thread_id'] if response_is_open_event?(i) }
      else
        update_msg_thread(json['email'], json['thread_id']) if response_is_open_event?(json)
      end
    end
    render status: 200, json: true
  end

private

  def update_msg_thread(email, thread_id)
    user = User.find_by_email(email) || Landlord.find_by_email(email)
    message_thread = MessageThread.find thread_id
    message_thread.mark_as_read(user) if user && message_thread
  end

  def response_is_open_event?(json)
    json['category'] && json['category'].include?('messages') && json['event'] == 'open'
  end
end
