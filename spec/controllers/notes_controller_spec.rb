require 'spec_helper'

describe NotesController, "/index" do
  before do
    create(:blog)
  end

  describe "normally" do
    before do
      @note = create(:note)
      get 'index'
    end

    specify { response.should be_success }
    specify { response.should render_template('notes/index') }
    specify { assigns(:notes).should =~ [@note] }
  end
  
  describe "with no note" do
    before do
      Note.delete_all
      get 'index'
    end
    
    specify { response.should be_success }
    specify { response.should render_template('notes/error') }
  end
end

describe NotesController, 'showing a single note' do
  render_views
  
  before do
    FactoryGirl.create(:blog)
    @note = FactoryGirl.create(:note)
  end

  def do_get
    get 'show', :permalink => "#{@note.id}-this-is-a-note"
  end

  it 'should be successful' do
    do_get()
    response.should be_success
  end

  it 'should set the page title to "this is a note"' do
    do_get
    assigns[:page_title].should == 'this is a note | test blog'
  end  
end

describe NotesController, "showing a non-existant note" do
  it 'should display a 404 error' do
    FactoryGirl.create(:blog)
    get 'show', :permalink => 'thistagdoesnotexist'

    response.status.should == 404
    response.should render_template("errors/404")
  end
end
