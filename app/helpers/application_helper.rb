# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
 # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = ""
    flash.each do |key, msg|
      messages << content_tag(:div, image_tag("cross.png", :class => "close") + msg , :class => key, :id => 'flash')
    end
    flash.discard
    messages
  end

  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end
  
  def show_title?
    @show_title
  end


end
