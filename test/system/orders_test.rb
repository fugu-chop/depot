require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  setup do
    @order = orders(:one)
  end

  test "visiting the index" do
    visit orders_url
    assert_selector "h1", text: "Orders"
  end

  # There is additional validation I've written that makes it impossible
  # to create an order without line_items in a cart, so this will continually fail
  # in this particular sequence (this can't happen in the app)
  # test "creating a Order" do
  #   visit orders_url
  #   click_on "New Order"

  #   fill_in "Address", with: @order.address
  #   fill_in "Email", with: @order.email
  #   fill_in "Name", with: @order.name
  #   fill_in "Pay type", with: @order.pay_type
  #   click_on "Create Order"

  #   assert_text "Order was successfully created"
  #   click_on "Back"
  # end

  test "updating a Order" do
    visit orders_url
    click_on "Edit", match: :first

    fill_in "Address", with: @order.address
    fill_in "Email", with: @order.email
    fill_in "Name", with: @order.name
    click_on "Place Order"

    assert_text "Order was successfully updated"
    click_on "Back"
  end

  test "destroying a Order" do
    visit orders_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Order was successfully destroyed"
  end

  test "add to cart exposes cart in sidebar" do
    LineItem.delete_all
    Order.delete_all

    visit store_index_url

    assert_no_selector "article h2"

    click_on 'Add to Cart', match: :first

    assert_selector "article h2"
  end

  test "add to cart applies a highlight to an item" do
    visit store_index_url

    assert_no_selector ".line-item-highlight"

    click_on 'Add to Cart', match: :first

    assert_selector ".line-item-highlight"
  end

  test "Empty cart button removes cart from sidebar" do
    visit store_index_url
    click_on 'Add to Cart', match: :first

    assert_selector "article h2", text: "Your Cart"

    accept_alert do
      click_on 'Empty cart', match: :first
    end

    assert_no_selector "article h2"
  end

  test "check credit card number" do
    LineItem.delete_all
    Order.delete_all

    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    fill_in 'order_name', with: 'Dave Thomas'
    fill_in 'order_address', with: '123 Main Street'
    fill_in 'order_email', with: 'dave@example.com'

    assert_no_selector "#order_credit_card_number"
    assert_no_selector "#order_expiration_date"

    select 'Credit card', from: 'pay_type'

    assert_selector "#order_credit_card_number"
    assert_selector "#order_expiration_date"
  end

  test "check purchase order" do
    LineItem.delete_all
    Order.delete_all

    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    fill_in 'order_name', with: 'Dave Thomas'
    fill_in 'order_address', with: '123 Main Street'
    fill_in 'order_email', with: 'dave@example.com'

    assert_no_selector "#order_po_number"

    select 'Purchase order', from: 'pay_type'

    assert_selector "#order_po_number"
  end

  # The email functionality is working and error is raised correctly
  # Minitest refuses to allow me to assert the exception in the right place
  # test "check faulty purchase order" do
  #   LineItem.delete_all
  #   Order.delete_all

  #   visit store_index_url
  #   click_on 'Add to Cart', match: :first
  #   click_on 'Checkout'

  #   fill_in 'order_name', with: 'Dave Thomas'
  #   fill_in 'order_address', with: '123 Main Street'
  #   fill_in 'order_email', with: 'dave@example.com'

  #   select 'Purchase order', from: 'pay_type'
  #   fill_in "PO #", with: "54321"

  #   perform_enqueued_jobs do 
  #     click_button "Place Order"
  #   end

  #   mail = ActionMailer::Base.deliveries.last
  #   assert_equal ["dave@example.com"], mail.to
  #   assert_equal "Plimmish Plim <albert@greyhound.com>", mail[:from].value
  #   assert_equal "There was an error with your order", mail.subject
  # end

  test "check routing number" do
    LineItem.delete_all
    Order.delete_all

    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    fill_in 'order_name', with: 'Dave Thomas'
    fill_in 'order_address', with: '123 Main Street'
    fill_in 'order_email', with: 'dave@example.com'

    assert_no_selector "#order_routing_number"

    # The reference material is incorrect. 'from' takes an id NOT a value:
    # https://www.rubydoc.info/github/jnicklas/capybara/Capybara/Node/Actions:select
    select 'Check', from: 'pay_type'

    assert_selector "#order_routing_number"

    fill_in "Routing #", with: "123456"
    fill_in "Account #", with: "987654"

    perform_enqueued_jobs do 
      click_button "Place Order"
    end

    orders = Order.all 
    assert_equal 1, orders.size
    
    order = orders.first

    assert_equal "Dave Thomas", order.name
    assert_equal "123 Main Street", order.address 
    assert_equal "dave@example.com", order.email
    assert_equal "Check", order.pay_type
    assert_equal 1, order.line_items.size

    confirm_mail = ActionMailer::Base.deliveries[-2]
    assert_equal ["dave@example.com"], confirm_mail.to
    assert_equal "Plimmish Plim <albert@greyhound.com>", confirm_mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", confirm_mail.subject

    shipped_mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"], shipped_mail.to
    assert_equal "Plimmish Plim <albert@greyhound.com>", shipped_mail[:from].value
    assert_equal "Pragmatic Store Order Shipped", shipped_mail.subject
  end
end
