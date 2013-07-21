require 'spec_helper'

describe StatusesController, "/index" do
  before do
    create(:blog)
    @status = create(:status)
  end

  describe "normally" do
    before do
      get 'index'
    end

    specify { response.should be_success }
    specify { response.should render_template('statuses/index') }
    specify { assigns(:statuses).should =~ [@status] }
  end
end

describe StatusesController, 'showing a single status' do
  render_views
  
  before do
    FactoryGirl.create(:blog)
    @status = FactoryGirl.create(:status)
  end

  def do_get
    get 'show', :permalink => "#{@status.id}-this-is-a-status"
  end

  it 'should be successful' do
    do_get()
    response.should be_success
  end

  it 'should set the page title to "this is a status"' do
    do_get
    assigns[:page_title].should == 'this is a status'
  end  
end

describe StatusesController, "showing a non-existant status" do
  it 'should display a 404 error' do
    FactoryGirl.create(:blog)
    get 'show', :permalink => 'thistagdoesnotexist'

    response.status.should == 404
    response.should render_template("errors/404")
  end
end
