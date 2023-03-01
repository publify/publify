# frozen_string_literal: true

class NotesSidebar < SidebarConfiguration
  description "Displays the latest notes"
  setting :title, "Notes"
  setting :count, 5, label: "Number of notes"

  attr_accessor :notes

  def parse_request(_contents, params)
    @notes = Note.published.page(params[:page]).per(count)
  end
end

SidebarRegistry.register_sidebar NotesSidebar
