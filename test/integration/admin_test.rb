require 'test_helper'

class AdminTest < ActionDispatch::IntegrationTest
  test "admin requires sign in" do
    get "/admin/posts"

    assert_redirected_to "/admin/login"
  end

  test "commissioner signs in and sees posts" do
    post "/admin/login", params: { email: "commish@example.com", password: "password" }
    follow_redirect!
    get "/admin/posts"

    assert_response :success
    assert_includes response.body, "Trade Deadline Recap"
  end

  test "wrong password is rejected" do
    post "/admin/login", params: { email: "commish@example.com", password: "nope" }
    get "/admin/posts"

    assert_redirected_to "/admin/login"
  end
end
