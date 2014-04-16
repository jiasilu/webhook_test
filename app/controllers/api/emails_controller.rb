class Api::EmailsController < ApplicationController
  def track
    arr = params['_json']
    if params[:_json].class.to_s == "Array"
      arr.each do |i|
        if i['category'] && i['category'].include?('messages')
          if i['event'] == 'open'
            user = User.find_by_email(i['email'])
            user ||= Landlord.find_by_email(i['email'])
            message_thread = MessageThread.find(i['thread_id'])
            message_thread.mark_as_read(user) if user
          end
        end
      end
    else
      unless params[:_json] == nil
        if params[:_json]['category'].include? 'messages'
          if params[:_json]['event'] == 'open'
            user = User.find_by_email(params[:_json]['email'])
            user ||= Landlord.find_by_email(params[:_json]['email'])
            message_thread = MessageThread.find(params[:_json]['thread_id'])
            message_thread.mark_as_read(user) if user
          end
        end
      end
    end
    render status: 200, json: true
  end
end
