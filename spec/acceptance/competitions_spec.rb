require_relative '../spec_helper.rb'

describe 'OSCGG-Web competitions', :type => :request do

  def app
    OSGCCWeb
  end

  describe "viewing competitions" do
    it "loads" do
      visit "/competitions"
      page.status_code.should == 200
    end
  end

  describe "creating competitions" do

    context "without a user" do
      it "returns a 404" do
        visit '/competitions/new'
        page.status_code.should == 404
      end

      it "via post returns a 404" do
        post '/competitions'
        last_response.status.should == 404
      end
    end

    context "with a non-admin user" do
      before :each do
        login_as regular_user
      end

      it "returns a 404" do
        visit '/competitions/new'
        page.status_code.should == 404
      end

      it "via post returns a 404" do
        post '/competitions'
        last_response.status.should == 404
      end
    end

    context "when logged in as an admin" do
      let(:params) do
        {
          :comp_name  => "test competition",
          :start_date => "2012-06-06",
          :start_time => "6:00pm",
          :end_date   => "2012-06-07",
          :end_time   => "6:00pm"
        }
      end

      before :each do
        login_as admin_user
      end

      it "creates a competition" do
        visit '/competitions/new'
        fill_in 'comp_name',  :with => "test competition"
        fill_in 'start_date', :with => "2012-06-06"
        fill_in 'start_time', :with => "6:00pm"
        fill_in 'end_date',   :with => "2012-06-07"
        fill_in 'end_time',   :with => "6:00pm"
        select 'Greenwich', :from => "timezone"
        click_on 'Create Competition'

        page.should have_content "test competition"
        page.should have_content "June 6, 2012 6:00 pm"
        page.should have_content "June 7, 2012 6:00 pm"
      end

      it "saves the timezone correctly for a competition" do
        visit '/competitions/new'
        fill_in 'start_date', :with => "2012-06-06"
        fill_in 'start_time', :with => "6:00pm"
        fill_in 'end_date',   :with => "2012-06-07"
        fill_in 'end_time',   :with => "6:00pm"
        select 'Greenwich', :from => "timezone"
        click_on 'Create Competition'

        page.should have_content "June 6, 2012 6:00 pm GMT"
        page.should have_content "June 7, 2012 6:00 pm GMT"
      end
    end
  end

  describe "editing competitions" do

    let(:competition) do
      Competition.create(:name          => "original name",
                         :start_date    => DateTime.yesterday,
                         :end_date      => DateTime.tomorrow,
                         :tz_identifier => 'Greenwich')
    end

    context "without a user" do
      it "doesn't show the edit button" do
        visit "/competitions/#{competition._id}"
        page.should_not have_content "Edit"
      end

      it "returns a 404" do
        visit "/competitions/#{competition._id}/edit"
        page.status_code.should == 404
      end

      it "via post returns a 404" do
        post "/competitions/#{competition._id}/edit"
        last_response.status.should == 404
      end
    end

    context "with a non-admin user" do
      before :each do
        login_as regular_user
      end

      it "doesn't show the edit button" do
        visit "/competitions/#{competition._id}"
        page.should_not have_content "Edit"
      end

      it "returns a 404" do
        visit "/competitions/#{competition._id}/edit"
        page.status_code.should == 404
      end

      it "via post returns a 404" do
        post "/competitions/#{competition._id}/edit"
        last_response.status.should == 404
      end
    end

    context "when logged in as an admin" do
      before :each do
        login_as admin_user
      end

      it "you can edit a competition" do
        visit "/competitions/#{competition._id}"
        click_on "Edit"

        fill_in 'comp_name',  :with => "new name"
        fill_in 'start_date', :with => "1987-01-25"
        fill_in 'start_time', :with => "12:00pm"
        fill_in 'end_date',   :with => "1987-01-26"
        fill_in 'end_time',   :with => "12:00pm"
        click_on "Update Competition"

        visit "/competitions/#{competition._id}"
        page.should have_content "new name"
        page.should have_content "January 25, 1987 12:00 pm"
        page.should have_content "January 25, 1987 12:00 pm"
      end
    end
  end
end
