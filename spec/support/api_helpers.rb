# Helper for API responses

# Method to return response status
def status
  response.status
end

# Method to return response content type
def content_type
  response.content_type
end

# Method to format API response as JSON
def json
  JSON.parse(response.body)
end

# Method to expect JSON content type
def expect_json_content
  expect(content_type).to eq('application/json')
end

# Method to expect success HTTP status and JSON type
def expect_success_status
  expect(status).to eq(200)
end

# Method to expect redirect HTTP status
def expect_redirect_status
  expect(status).to eq(302)
end

# Method to expect forbidden HTTP status
def expect_forbidden_status
  expect(status).to eq(403)
end

# Method to expect unprocessable entity HTTP status
def expect_unprocessable_status
  expect(status).to eq(422)
end

# Method to expect Internal server error HTTP status
def expect_server_error_status
  expect(status).to eq(500)
end

# Method to expect Unauthorized Access
def expect_unauthorized_access
  expect(status).to eq(401)
end

# Method to expect NotFound status
def expect_not_found_status
  expect(status).to eq(404)
end

# Added a method to expect access token with other details
def expect_token_headers
  headers = response.headers
  expect(headers['access-token']).to be_present
  expect(headers['client']).to be_present
  expect(headers['token-type']).to be_present
  expect(headers['expiry']).to be_present
  expect(headers['uid']).to be_present
end

# To stub sign_in
def token_sign_in user
  auth_headers = user.create_new_auth_token
  request.headers.merge!(auth_headers)
end
