# frozen_string_literal: true

class ProposalsController < ApplicationController
  def create
    @place = Place.find_or_create_by(place_params)
    @poll = Poll.find_by(slug_params)
    @proposal = Proposal.new(poll: @poll, place: @place, user: current_user)
    if @proposal.save
      render @proposal
    else
      render partial: 'polls/proposals', locals: { poll: @poll }, status: :unprocessable_entity
    end
  end

  private

  def place_params
    params.require(:place).permit(:name, :address, :country, :lat, :long)
  end

  def slug_params
    params.require(:poll).permit(:slug)
  end
end
