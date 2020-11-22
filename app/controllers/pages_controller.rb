# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  layout 'devise', only: :home

  def home; end
end
