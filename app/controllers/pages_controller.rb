class PagesController < ApplicationController
  def index
    Rails.logger.debug "Using Controller Action: Pages#Index".green
    Rails.logger.debug params.to_s.green
    render_cell(
      page_cell: Page::Cell::Index,
      header_cell: Page::Header::Cell::Index
    )
  end
end