require "test_helper"

class SupportMailboxTest < ActionMailbox::TestCase
  test "we create a SupportRequest when we get a support email" do
    receive_inbound_email_from_mail(
      to: "support@example.com",
      from: "test@test.com",
      subject: "Need help",
      body: "I can't figure out how to check out!!"
    )

    support_request = SupportRequest.last
    assert_equal "test@test.com", support_request.email
    assert_equal "Need help", support_request.subject
    assert_equal "I can't figure out how to check out!!", support_request.body
    assert_nil support_request.order
  end

  test "we create a SupportRequest with the most recent order" do
    recent_order = orders(:one)
    older_order = orders(:another_one)
    non_customer = orders(:other_customer)

    receive_inbound_email_from_mail(
      to: "support@example.com",
      from: recent_order.email,
      subject: "Need help",
      body: "I can't figure out how to check out!"
    )

    support_request = SupportRequest.last
    assert_equal recent_order.email, support_request.email
    assert_equal "Need help", support_request.subject
    assert_equal "I can't figure out how to check out!", support_request.body 
    assert_equal recent_order, support_request.order
  end

  test "we create a SupportRequest with without an order" do
    receive_inbound_email_from_mail(
      to: "support@example.com",
      from: "test@email.com",
      subject: "Need help",
      body: "I can't figure out how to check out!"
    )

    support_request = SupportRequest.last
    assert_equal "test@email.com", support_request.email
    assert_equal "Need help", support_request.subject
    assert_equal "I can't figure out how to check out!", support_request.body 
    assert_nil support_request.order
  end
end
