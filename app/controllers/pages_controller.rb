class PagesController < ApplicationController
  def index
    puts "Using Controller Action: Pages#Index".green
    render_cell(
      page_cell: Page::Cell::Index,
      header_cell: Page::Header::Cell::Index
    )
  end
end