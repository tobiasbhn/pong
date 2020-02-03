class PagesController < ApplicationController
  def index
    render_cell(
      page_cell: Page::Cell::Index,
      header_cell: Page::Header::Cell::Index
    )
  end
end