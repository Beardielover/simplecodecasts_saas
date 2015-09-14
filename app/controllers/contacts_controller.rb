class ContactsController < ApplicationController
   def new
       @contact = Contact.new
   end
      
    require 'sendgrid-ruby'
            
   def create
  @contact = Contact.new(contact_params)
     if @contact.save
       name = params[:contact][:name]
       email = params[:contact][:email]
       body = params[:contact][:comments]
       
       client = SendGrid::Client.new(api_user: 'Kairus', api_key: 'handywandy99')
      
      mail = SendGrid::Mail.new do |m|
          m.to = 'ritchiekai@gmail.com'
          m.from = email
          m.subject = 'Contact Form From: ' + name
          m.text = body
        end

        puts client.send(mail) 
      # ContactMailer.contact_email(name, email, body).deliver
      
       flash[:success] = 'Message sent.'
       redirect_to new_contact_path
     else
       flash[:danger] = 'Error occured, message has not been sent.'
       redirect_to new_contact_path
     end
   end
   
   private
      def contact_params
         params.require(:contact).permit(:name, :email, :comments)
      end
end