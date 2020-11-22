# frozen_string_literal: true

class PollMailer < ApplicationMailer
  def send_invite
    @user = params[:user]
    @recipient = params[:recipient]
    @poll_url = poll_url(params[:poll].slug)

    mail(to: @recipient, subject: "Aidez #{@user.full_name} à trouvez où manger ce midi.")
  end
end
