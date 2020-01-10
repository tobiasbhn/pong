class PagesController < ApplicationController
  before_action :authenticate!, :check_password!, only: :show

  def index
    puts "Using Controller Action: Application#Index".green
    render_cell(
      page_cell: Page::Cell::Index,
      header_cell: Head::Cell::Index
    )
  end

  def host
    puts "Using Controller Action: Application#Host".green
    render_cell(
      page_cell: Page::Cell::Host,
      header_cell: Head::Cell::Host
    )
  end

  def join
    puts "Using Controller Action: Application#Join".green
    render_cell(
      page_cell: Page::Cell::Join,
      header_cell: Head::Cell::Join
    )
  end

  def show
    # TODO: dynamicly select which cell depending on game mode and consumer type
    puts "Using Controller Action: Application#Show".green
    render_cell(
      page_cell: Page::Cell::Show,
      header_cell: Head::Cell::Show
    )
  end
end