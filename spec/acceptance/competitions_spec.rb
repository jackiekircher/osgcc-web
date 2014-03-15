require_relative '../spec_helper.rb'

describe 'OSCGG-Web competitions', :type => :feature do

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
          :start_time => "18:00",
          :end_date   => "2012-06-07",
          :end_time   => "18:00"
        }
      end

      before :each do
        login_as admin_user
      end

      it "creates a competition" do
        visit '/competitions/new'
        fill_in 'comp_name',  :with => "test competition"
        fill_in 'start_date', :with => "2012-06-06"
        fill_in 'start_time', :with => "18:00"
        fill_in 'end_date',   :with => "2012-06-07"
        fill_in 'end_time',   :with => "18:00"
        select 'UTC', :from => "timezone"
        click_on 'Create Competition'

        page.should have_content "test competition"
        page.should have_content "06/06/12 06:00pm"
        page.should have_content "06/07/12 06:00pm"
      end

      it "saves the timezone correctly for a competition" do
        visit '/competitions/new'
        fill_in 'comp_name',  :with => "test competition"
        fill_in 'start_date', :with => "2012-06-06"
        fill_in 'start_time', :with => "18:00"
        fill_in 'end_date',   :with => "2012-06-07"
        fill_in 'end_time',   :with => "18:00"
        select 'UTC', :from => "timezone"
        click_on 'Create Competition'

        page.should have_content "06/06/12 06:00pm"
        page.should have_content "06/07/12 06:00pm UTC"
      end
    end
  end

  describe "editing competitions" do

    let(:competition) do
      Competition.create(:name       => "original name",
                         :start_time => Time.now - 1.day,
                         :end_time   => Time.now + 1.day,
                         :time_zone   => 'UTC')
    end

    context "without a user" do
      it "doesn't show the edit button" do
        visit "/competitions/#{competition.id}"
        page.should_not have_content "Edit"
      end

      it "returns a 404" do
        visit "/competitions/#{competition.id}/edit"
        page.status_code.should == 404
      end

      it "via post returns a 404" do
        post "/competitions/#{competition.id}/edit"
        last_response.status.should == 404
      end
    end

    context "with a non-admin user" do
      before :each do
        login_as regular_user
      end

      it "doesn't show the edit button" do
        visit "/competitions/#{competition.id}"
        page.should_not have_content "Edit"
      end

      it "returns a 404" do
        visit "/competitions/#{competition.id}/edit"
        page.status_code.should == 404
      end

      it "via post returns a 404" do
        post "/competitions/#{competition.id}/edit"
        last_response.status.should == 404
      end
    end

    context "when logged in as an admin" do
      before :each do
        login_as admin_user
      end

      it "you can edit a competition" do
        visit "/competitions/#{competition.id}"
        click_on "Edit"

        fill_in 'comp_name',  :with => "new name"
        fill_in 'start_date', :with => "1987-01-25"
        fill_in 'start_time', :with => "12:00"
        fill_in 'end_date',   :with => "1987-01-26"
        fill_in 'end_time',   :with => "12:00"
        click_on "Update Competition"

        visit "/competitions/#{competition.id}"
        page.should have_content "new name"
        page.should have_content "1/25/87 12:00pm"
        page.should have_content "1/26/87 12:00pm"
      end
    end
  end
end
