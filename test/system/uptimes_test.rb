require "application_system_test_case"

class UptimesTest < ApplicationSystemTestCase
  setup do
    @uptime = uptimes(:one)
  end

  test "visiting the index" do
    visit uptimes_url
    assert_selector "h1", text: "Uptimes"
  end

  test "should create uptime" do
    visit uptimes_url
    click_on "New uptime"

    check "Cancelled" if @uptime.cancelled
    fill_in "Host", with: @uptime.host
    fill_in "Interval", with: @uptime.interval
    click_on "Create Uptime"

    assert_text "Uptime was successfully created"
    click_on "Back"
  end

  test "should update Uptime" do
    visit uptime_url(@uptime)
    click_on "Edit this uptime", match: :first

    check "Cancelled" if @uptime.cancelled
    fill_in "Host", with: @uptime.host
    fill_in "Interval", with: @uptime.interval
    click_on "Update Uptime"

    assert_text "Uptime was successfully updated"
    click_on "Back"
  end

  test "should destroy Uptime" do
    visit uptime_url(@uptime)
    click_on "Destroy this uptime", match: :first

    assert_text "Uptime was successfully destroyed"
  end
end
