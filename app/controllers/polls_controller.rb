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

  private

  def poll_params
    params.require(:poll).permit(
      :title,
      :scheduled_at,
      :due_at,
    )
  end
end
