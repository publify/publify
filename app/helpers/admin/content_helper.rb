module Admin::ContentHelper
  def toggle_element(element, label=t('.change'))
    link_to(label, "##{element}", :"data-toggle" => :collapse)
  end
end
