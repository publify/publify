require File.dirname(__FILE__) + '/../spec_helper'

module StateSpecHelper
  def content_should_delegate_method_to_state(method, *expected_args)
    if expected_args.blank?
      expected_args << :no_args
    end

    @state.should_receive(method).with(*expected_args).and_return(true)
    method_args = *(expected_args)[1..-1]

    if method_args.blank?
      @content.send(method).should_be true
    else
      @content.send(method, *method_args).should_be true
    end
  end
end

context 'With new content and a mocked state...' do
  include StateSpecHelper

  setup do
    @state = mock('state', :null_object => true)
    @state.stub!(:memento).and_return('ContentState::Unclassified')
    ContentState::Unclassified.stub!(:instance).and_return(@state)
    @content = Comment.new(:author => 'Piers', :body => 'Body')
  end

  specify '#published? should delegate to state' do
    content_should_delegate_method_to_state :published?, @content
  end

  specify '#just_published? should delegate to state' do
    content_should_delegate_method_to_state :just_published?
  end

  specify '#just_changed_published_status? should delegate to state' do
    content_should_delegate_method_to_state :just_changed_published_status?
  end

  specify '#withdrawn? should delegate to state' do
    content_should_delegate_method_to_state :withdrawn?
  end

  specify '#publication_pending? should delegate to state' do
    content_should_delegate_method_to_state :publication_pending?
  end

  specify '#post_trigger should delegate to state' do
    content_should_delegate_method_to_state :post_trigger, @content
  end

  specify '#after_save should delegate to state' do
    content_should_delegate_method_to_state :after_save, @content
  end

  specify '#send_notifications should delegate to state' do
    content_should_delegate_method_to_state :send_notifications, @content
  end

  specify '#withdraw should delegate to state' do
    content_should_delegate_method_to_state :withdraw, @content
  end

  specify '#published= should delegate to state' do
    @state.should_receive(:change_published_state).with(@content, true).and_return(true)
    @content.published = true
  end

  specify '#published_at= should delegate to state' do
    timestamp = Time.now
    @state.should_receive(:set_published_at).with(@content, timestamp).and_return(true)
    @content.published_at = timestamp
  end


end

context 'Given a comment and mocked state' do
  include StateSpecHelper

  setup do
    @state = mock('state', :null_object => true)
    @state.stub!(:memento).and_return('ContentState::Unclassified')
    ContentState::Unclassified.stub!(:instance).and_return(@state)
    @content = Comment.new(:author => 'Piers', :body => 'Body')
  end

  specify '#spam? should delegate to state' do
    @state.should_receive(:is_spam?).with(@content).and_return(true)
    @content.spam?.should == true
  end

  specify '#status_confirmed? should delegate to state' do
    content_should_delegate_method_to_state :status_confirmed?, @content
  end

  specify '#mark_as_ham should delegate to state' do
    content_should_delegate_method_to_state :mark_as_ham, @content
  end

  specify '#mark_as_spam should delegate to state' do
    content_should_delegate_method_to_state :mark_as_spam, @content
  end

  specify '#confirm_classification should delegate to state' do
    content_should_delegate_method_to_state :confirm_classification, @content
  end
end

context 'Given an article and mocked state' do
  include StateSpecHelper

  setup do
    @state = mock('state', :null_object => true)
    @state.stub!(:memento).and_return('ContentState::New')
    ContentState::New.stub!(:instance).and_return(@state)
    @content = Article.new(:author => 'Piers', :title => 'title', :body => 'Body')
  end

  specify '#send_pings should delegate to state' do
    @state.should_receive(:send_pings).and_return(true)
    @content.send_pings.should_be true
  end
end
