require File.dirname(__FILE__) + '/test_helper'

class SitealizerController 
  def rescue_action(e) raise e end
  SA_CONFIG   = {'sitealizer' => {'username' => 'test', 'password' => 'test', 'access_type' => 'public'}}
end

class SitealizerControllerTest < Test::Unit::TestCase
  set_fixture_class :sitealizer => 'SiteTracker'
  fixtures :sitealizer
  
  def setup
    @controller = SitealizerController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_login
    get :login
    assert_template 'login'
    
    post :login, :username => 'test', :password => 'test'
    assert_response :redirect
    assert_redirected_to :action => 'index'
    assert_not_nil @response.cookies["sitealizer"][0]
  end
  
  def test_login_fails
    post :login, :username => 'me', :password => 'me'
    assert_not_nil flash[:notice]
    assert_template 'login'
  end
  
  def test_logout
    get :logout
    assert @response.cookies["sitealizer"].empty?
    assert_response :redirect
    assert_redirected_to :action => 'login'
  end
  
  def test_index
    get :index
    assert_template 'index'
    get :index, :year => '2006', :month => '03'
    assert_template 'index'
  end
  
  def test_menu
    get :menu
    assert_template 'menu'
    assert_not_nil assigns(:months)
    assert_not_nil assigns(:years)
  end
  
  def test_summary
    get :summary
    assert_equal 9, assigns(:total_hits)
    assert_equal 7, assigns(:unique_hits)
    assert_equal 9, assigns(:year_hits)
    assert_equal 7, assigns(:year_uniq)  
    assert_equal [1, 2, 3, "Mar 01 2007"], assigns(:daily_hits).first
    assert_equal ["Mar 2007", 7, 9, "March 2007"], assigns(:month_hits)[2]
    assert_template 'summary'
  end

  def test_summary_no_records
    get :summary, :year => '2006', :month => '01'
    [:total_hits, :unique_hits, :year_hits, :year_uniq].each do |var|
      assert_equal 0, assigns(var)
    end
    
    expected = [[1, 0, 0, "Jan 01 2006"], [2, 0, 0, "Jan 02 2006"], [3, 0, 0, "Jan 03 2006"], 
                [4, 0, 0, "Jan 04 2006"], [5, 0, 0, "Jan 05 2006"], [6, 0, 0, "Jan 06 2006"], 
                [7, 0, 0, "Jan 07 2006"], [8, 0, 0, "Jan 08 2006"], [9, 0, 0, "Jan 09 2006"], 
                [10, 0, 0, "Jan 10 2006"], [11, 0, 0, "Jan 11 2006"], [12, 0, 0, "Jan 12 2006"], 
                [13, 0, 0, "Jan 13 2006"], [14, 0, 0, "Jan 14 2006"], [15, 0, 0, "Jan 15 2006"], 
                [16, 0, 0, "Jan 16 2006"], [17, 0, 0, "Jan 17 2006"], [18, 0, 0, "Jan 18 2006"], 
                [19, 0, 0, "Jan 19 2006"], [20, 0, 0, "Jan 20 2006"], [21, 0, 0, "Jan 21 2006"], 
                [22, 0, 0, "Jan 22 2006"], [23, 0, 0, "Jan 23 2006"], [24, 0, 0, "Jan 24 2006"], 
                [25, 0, 0, "Jan 25 2006"], [26, 0, 0, "Jan 26 2006"], [27, 0, 0, "Jan 27 2006"], 
                [28, 0, 0, "Jan 28 2006"], [29, 0, 0, "Jan 29 2006"], [30, 0, 0, "Jan 30 2006"], 
                [31, 0, 0, "Jan 31 2006"]]
    assert_equal expected, assigns(:daily_hits)

    expected = [["Jan 2006", 0, 0, "January 2006"], ["Feb 2006", 0, 0, "February 2006"], 
                ["Mar 2006", 0, 0, "March 2006"], ["Apr 2006", 0, 0, "April 2006"], 
                ["May 2006", 0, 0, "May 2006"], ["Jun 2006", 0, 0, "June 2006"], 
                ["Jul 2006", 0, 0, "July 2006"], ["Aug 2006", 0, 0, "August 2006"], 
                ["Sep 2006", 0, 0, "September 2006"], ["Oct 2006", 0, 0, "October 2006"], 
                ["Nov 2006", 0, 0, "November 2006"], ["Dec 2006", 0, 0, "December 2006"]]
    assert_equal expected, assigns(:month_hits)
    
    assert_template 'summary'
  end

  def test_hourly_stats
    get :hourly_stats
    assert_equal 9, assigns(:total_hits)
    
    # Hour, Visits, Hits
    assert_equal ["00", 3, 4], assigns(:hourly_hits).first
    assert_template 'hourly_stats'
  end
  
  def test_hourly_stats_no_records
    get :hourly_stats, :year => '2006', :month => '01'
    expected = [["00", 0, 0], ["01", 0, 0], ["02", 0, 0], ["03", 0, 0], ["04", 0, 0], ["05", 0, 0], 
                ["06", 0, 0], ["07", 0, 0], ["08", 0, 0], ["09", 0, 0], ["10", 0, 0], ["11", 0, 0], 
                ["12", 0, 0], ["13", 0, 0], ["14", 0, 0], ["15", 0, 0], ["16", 0, 0], ["17", 0, 0], 
                ["18", 0, 0], ["19", 0, 0], ["20", 0, 0], ["21", 0, 0], ["22", 0, 0], ["23", 0, 0]]
    assert_equal expected, assigns(:hourly_hits)
    assert_template 'hourly_stats'
  end
  
  def test_search_stats
    get :search_stats

    assert_equal 2, assigns(:keywords).size
    expected = [{:total => 3, :query => "sitealizer"},{:total => 1, :query => "sitealizer rails plugin"}]
    expected.each do |term|
      assert_equal term, assigns(:keywords)[expected.index(term)]
    end    
    
    assert_equal 2, assigns(:robots).size
    expected = [{:total => 2, :name => "Googlebot"},{:total => 1, :name => "MSNBot"}]
    expected.each do |robot|
      assert_equal robot, assigns(:robots)[expected.index(robot)]
    end

    assert_equal 3, assigns(:engines).size
    expected = [{:total=>2, :domain=>"search.aol.com"}, {:total=>1, :domain=>"www.altavista.com"}, 
                {:total=>1, :domain=>"search.yahoo.com"}]
    expected.each do |engine|
      assert_equal engine, assigns(:engines)[expected.index(engine)]
    end
    
    assert_template 'search_stats'
  end
  
  def test_search_stats_no_records
    get :search_stats, :year => '2006', :month => '01'
    [:keywords, :engines, :robots].each do |var|
      assert assigns(var).empty?
    end
    assert_template 'search_stats'    
  end
  
  def test_visitor_info
    get :visitor_info
    
    assert_equal 4, assigns(:browsers).size
    expected = ["Netscape","Other","MSIE","Safari"]
    expected.each do |browser|
      assert_equal browser, assigns(:browsers)[expected.index(browser)][:browser][:type]
    end
    
    assert_equal 3, assigns(:platforms).size
    expected = ["Windows","Other","Macintosh"]
    expected.each do |platform|
      assert_equal platform, assigns(:platforms)[expected.index(platform)][:name]
    end
    
    assert_equal 7, assigns(:hosts).size
    expected = ["41.41.41.41","1.1.1.1","123.4.5.678","31.31.31.31","51.51.51.51","3.3.3.3","2.2.2.2"]
    expected.each do |host|
      assert_equal host, assigns(:hosts)[expected.index(host)]["ip"]
    end
    
    assert_equal 4, assigns(:languages).size
    expected = ["en",nil,"fr-fr","pt-pt"]
    expected.each do |language|
      assert_equal language, assigns(:languages)[expected.index(language)][:language]
    end
    
    assert_template 'visitor_info'
  end
  
  def test_visitor_info_no_records
    get :visitor_info, :year => '2006', :month => '01'
    assert_equal 0, assigns(:total_hits)
    [:browsers, :platforms, :hosts, :languages].each do |var|
      assert assigns(var).empty?
    end
    assert_template 'visitor_info'    
  end
  
  def test_referrer_stats
    get :referrer_stats
    assert_not_nil assigns(:page_urls)
    assert_equal 2, assigns(:page_urls).size
    [[0,"/"],[1,"/account"]].each do |page|
      assert_equal page[1], assigns(:page_urls)[page[0]].path
    end
    assert_not_nil assigns(:referers)
    assert_equal 5, assigns(:referers).size
    assert_template 'referrer_stats'
  end
  
  def test_referrer_stats_no_records
    get :referrer_stats, :year => '2007', :month => '01'
    assert_equal 0, assigns(:total_hits)
    [:page_urls, :referers].each do |var|
      assert assigns(var).empty?
    end
    assert_template 'referrer_stats'
  end
  
end
