class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = current_user.conversations
  end

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages
    render partial: 'conversations/conversation', locals: { conversation: @conversation }
  end

  def create
    agent = User.find(params[:agent_id])
    broker = current_user

    # Check if a conversation already exists
    conversation = Conversation.joins(:participants).where(participants: { user_id: [agent.id, broker.id] }).distinct.first

    unless conversation
      conversation = Conversation.create!
      conversation.participants.create(user: agent)
      conversation.participants.create(user: broker)
    end

    redirect_to conversation_path(conversation)
  end
end