# frozen_string_literal: true

class PollsController < ApplicationController
  def new
    @poll = Poll.new
  end

  def create
    @poll = Poll.new(**poll_params, created_by: current_user)

    if @poll.save
      redirect_to poll_path(@poll.slug)
    else
      render :new
    end
  end

  def show
    @poll = Poll.includes(:created_by).find_by(slug: params[:slug])
  end

  def send_invites
    @poll = Poll.find_by(slug: params[:poll_id])
    emails = invite_params.split(';')
    emails.each do |email|
      PollMailer.with(user: current_user, recipient: email, poll: @poll).send_invite.deliver_later
    end
    redirect_to poll_path(@poll.slug), notice: "Email(s) d'invitation bien envoyé(s)"
  end

  private

  def poll_params
    params.require(:poll).permit(
      :title,
      :scheduled_at,
      :due_at,
    )
  end

  def invite_params
    params.require(:invite).require(:emails)
  end
end
