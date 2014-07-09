require "spec_helper"

describe NotesHelper do

  describe "get_reply_context_url" do

    it "return link to the original reply the reply" do
      reply = {'user' => {'name' => 'truc', 'entities' => {'url' => {'urls' => [{'expanded_url' => 'an url'}]}}}}
      expect(get_reply_context_url(reply)).to eq("<a href=\"an url\">truc</a>")
    end

    it "return link from the reply" do
      reply = {'user' => {'name' => 'truc', 'entities' => {}}}
      expect(get_reply_context_url(reply)).to eq("<a href=\"https://twitter.com/truc\">truc</a>")
    end

  end

  describe "get_reply_context_url" do

    it "return link from context" do
      reply = {'id_str' => '123456789', 'created_at' => DateTime.new(2014,1,23,13,47), 'user' => {'screen_name' => 'a screen name', 'entities' => {'url' => {'urls' => [{'expanded_url' => 'an url'}]}}}}
      expect(get_reply_context_twitter_link(reply)).to eq("truc")
    end

  end

end
