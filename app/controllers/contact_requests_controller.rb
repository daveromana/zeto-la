class ContactRequestsController < ApplicationController
  def new
    @contact_request = ContactRequest.new
    @recipient_user = User.find(params[:user_id])
  end

  def create
    @contact_request = ContactRequest.new(contact_request_params)
    @contact_request.user = User.find(params[:user_id])
    if @contact_request.save
      ContactRequestMailer.new_contact_request_receipt(current_user, @contact_request).deliver
      ContactRequestMailer.new_contact_request(current_user, @contact_request).deliver
      flash[:notice] = "Successfully sent your request."
      redirect_to users_path
    else
      flash[:notice] = "Error please try again."
      render groups_path
    end
  end

  private

  def contact_request_params
    params.require(:contact_request).permit(:title, :description)
  end
end
