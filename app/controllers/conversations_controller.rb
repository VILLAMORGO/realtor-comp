class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = current_user.conversations
    @selected_conversation = Conversation.find_by(id: params[:selected_conversation_id]) if params[:selected_conversation_id]
  end

  def show
    @conversation = current_user.conversations.find(params[:id])
    @messages = @conversation.messages
  end

  def create
    agent = User.find(params[:agent_id])
    broker = current_user
  
    # Check if a conversation exists between the current user and the specified agent
    conversation = Conversation.joins(:participants)
                                .where(participants: { user_id: [agent.id, broker.id] })
                                .group('conversations.id')
                                .having('COUNT(DISTINCT participants.user_id) = 2')
                                .first
  
    unless conversation
      conversation = Conversation.create!
      conversation.participants.create!(user: agent)
      conversation.participants.create!(user: broker)
    end
  
    redirect_to conversation
  end
end