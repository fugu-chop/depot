require "application_system_test_case"

class CartsTest < ApplicationSystemTestCase
  setup do
    @cart = carts(:one)
  end

  test "visiting the index" do
    visit carts_url
    assert_selector "h1", text: "Carts"
  end

  # These are skipped because there is session params based
  # validation that we cannot easily be mocked in a system test. 
  # See the carts_controller_test.rb for further detail.
  # test "creating a Cart" do
  #   visit carts_url
  #   click_on "New Cart"

  #   click_on "Create Cart"

  #   assert_text "Cart was successfully created"
  #   click_on "Back"
  # end

  # test "updating a Cart" do
  #   visit carts_url
  #   click_on "Edit", match: :first

  #   click_on "Update Cart"

  #   assert_text "Cart was successfully updated"
  #   click_on "Back"
  # end

  test "destroying a Cart" do
    visit carts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Programming Ruby 1.9"
  end
end
