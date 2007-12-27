# Requires that XmlSimple is already loaded, like it is from within script/console in the latest beta Rails
# Author: David Heinemeier Hansson, 37signals

require 'yaml'
require 'net/https'

class BackpackAPI
  attr_accessor :username, :token, :current_page_id

  def initialize(username, token)
    @username, @token = username, token
    connect
  end

  def connect(use_ssl = false)
    @connection = Net::HTTP.new("#{@username}.backpackit.com", use_ssl ? 443 : 80)
    @connection.use_ssl = use_ssl
    @connection.verify_mode = OpenSSL::SSL::VERIFY_NONE if use_ssl
  end

  def page_id=(id)
    self.current_page_id = id
  end
  alias :pi= :page_id=

  def request(path, parameters = {}, second_try = false)
    parameters = { "token" => @token }.merge(parameters)

    response = @connection.post("/ws/#{path}", parameters.to_yaml, "X-POST_DATA_FORMAT" => "yaml")

    if response.code == "200"
      result = XmlSimple.xml_in(response.body)
      result.delete "success"
      result.empty? ? true : result
    elsif response.code == "302" && !second_try
      connect(true)
      request(path, parameters, true)
    else
      raise "Error occured (#{response.code}): #{response.body}"
    end
  end
  alias :r :request


  # Items ----

  def list_items(page_id = current_page_id)
    request "page/#{page_id}/items/list"
  end
  alias :li :list_items

  def create_item(content, page_id = current_page_id)
    request "page/#{page_id}/items/add", "item" => { "content" => content }
  end
  alias :ci :create_item

  def update_item(item_id, content, page_id = current_page_id)
    request "page/#{page_id}/items/update/#{item_id}", "item" => { "content" => content }
  end
  alias :ui :update_item

  def destroy_item(item_id, page_id = current_page_id)
    request "page/#{page_id}/items/destroy/#{item_id}"
  end
  alias :di :destroy_item

  def toggle_item(item_id, page_id = current_page_id)
    request "page/#{page_id}/items/toggle/#{item_id}"
  end
  alias :ti :toggle_item

  def move_item(item_id, direction, page_id = current_page_id)
    request "page/#{page_id}/items/move/#{item_id}", "direction" => "move_#{direction}"
  end
  alias :mi :move_item


  # Notes ----

  def list_notes(page_id = current_page_id)
    request "page/#{page_id}/notes/list"
  end
  alias :li :list_notes

  def create_note(title, body, page_id = current_page_id)
    request "page/#{page_id}/notes/create", "note" => { "title" => title, "body" => body }
  end
  alias :cn :create_note

  def update_note(note_id, title, body, page_id = current_page_id)
    request "page/#{page_id}/notes/update/#{note_id}", "note" => { "title" => title, "body" => body }
  end
  alias :un :update_note

  def destroy_note(note_id, page_id = current_page_id)
    request "page/#{page_id}/notes/destroy/#{note_id}"
  end
  alias :dn :destroy_note


  # Emails ----

  def list_emails(page_id = current_page_id)
    request "page/#{page_id}/emails/list"
  end
  alias :le :list_emails

  def show_email(email_id, page_id = current_page_id)
    request "page/#{page_id}/emails/show/#{email_id}"
  end
  alias :se :show_email

  def destroy_email(email_id, page_id = current_page_id)
    request "page/#{page_id}/emails/destroy/#{email_id}"
  end
  alias :de :destroy_email


  # Tags ----

  def list_pages_with_tag(tag_id)
    request "tags/select/#{tag_id}"
  end
  alias :lpt :list_pages_with_tag

  def tag_page(tags, page_id = current_page_id)
    request "page/#{page_id}/tags/tag", "tags" => tags
  end
  alias :tp :tag_page


  # Pages ----

  def list_pages
    request "pages/all"
  end
  alias :lp :list_pages

  def create_page(title, body)
    request "pages/new", "page" => { "title" => title, "description" => body }
  end
  alias :cp :create_page

  def show_page(page_id = current_page_id)
    request "page/#{page_id}"
  end
  alias :sp :show_page

  def destroy_page(page_id = current_page_id)
    request "page/#{page_id}/destroy"
  end
  alias :dp :destroy_page

  def update_title(title, page_id = current_page_id)
    request "page/#{page_id}/update_title", "page" => { "title" => title }
  end
  alias :ut :update_title

  def update_body(body, page_id = current_page_id)
    request "page/#{page_id}/update_body", "page" => { "description" => body }
  end
  alias :ub :update_body

  def link_page(linked_page_id, page_id = current_page_id)
    request "page/#{page_id}/link", "linked_page_id" => linked_page_id
  end
  alias :lip :link_page

  def unlink_page(linked_page_id, page_id = current_page_id)
    request "page/#{page_id}/unlink", "linked_page_id" => linked_page_id
  end
  alias :ulip :unlink_page

  def share_page(email_addresses, public_page = nil, page_id = current_page_id)
    parameters = { "email_addresses" => email_addresses }
    parameters = parameters.merge({ "page" => { "public" => public_page ? "1" : "0" }}) unless public_page.nil?
    request "page/#{page_id}/share", parameters
  end


  # Reminders ---

  def list_reminders
    request "reminders"
  end
  alias :lr :list_reminders

  def create_reminder(content, remind_at = "")
    request "reminders/create", "reminder" => { "content" => content, "remind_at" => remind_at }
  end
  alias :cr :create_reminder

  def update_reminder(reminder_id, content, remind_at)
    request "reminders/update/#{reminder_id}", "reminder" => { "content" => content, "remind_at" => remind_at }
  end
  alias :ur :update_reminder

  def destroy_reminder(reminder_id)
    request "reminders/destroy/#{reminder_id}"
  end
  alias :dr :destroy_reminder
end
