module OmniauthMacros
  def mock_auth_hash(provider, name,email)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new(
      provider: provider,
      uid: '123456',
      info: {
        name: name,
        email: email,
      }
    )
  end

  def mock_auth_invalid_hash(provider)
    OmniAuth.config.mock_auth[provider.to_sym] = :invalid_credentials
  end
end
