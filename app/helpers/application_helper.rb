module ApplicationHelper
  def html_head
    @html_head.presence || cell(Head::Cell::Default).()
  end
end
