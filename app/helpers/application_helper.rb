module ApplicationHelper

  def current_user
    user_id = session[:user_id] 
    if user_id
      begin
        @user = User.find(user_id)
      rescue
        @user = nil
      end
    else
      @user = nil
    end
  end

  # add this to app/helpers/application_helper.rb
  # http://www.emersonlackey.com/article/rails3-error-messages-for-replacemen
  def errors_for(object, message=nil)
    html = ""
    unless object.nil? || object.errors.blank?
      html << "<div class='alert alert-error #{object.class.name.humanize.downcase}Errors'>\n"
      if message.blank?
        if object.new_record?
          html << "\t\t<h5>There was a problem creating the #{object.class.name.humanize.downcase}</h5>\n"
        else
          html << "\t\t<h5>There was a problem updating the #{object.class.name.humanize.downcase}</h5>\n"
        end    
      else
        html << "<h5>#{message}</h5>"
      end  
      html << "\t\t<ul>\n"
      object.errors.full_messages.each do |error|
        html << "\t\t\t<li>#{error}</li>\n"
      end
      html << "\t\t</ul>\n"
      html << "\t</div>\n"
    end
    html
  end  

	# polyfill for jquery-ujs in rails 2.x
	# see https://github.com/rails/jquery-ujs/wiki/Manual-installing-and-Rails-2
	def csrf_meta_tags
		if protect_against_forgery?
			out = %(<meta name="csrf-param" content="%s"/>\n)
			out << %(<meta name="csrf-token" content="%s"/>)
			out % [ Rack::Utils.escape_html(request_forgery_protection_token),
					Rack::Utils.escape_html(form_authenticity_token) ]
		end
 	end

end
