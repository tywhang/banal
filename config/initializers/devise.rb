Devise.setup do |config|
  config.secret_key = '608f660e0c6c32138e77aa3b55d0ee8e6fb0d099f7d3b4e907c514e478de9f30f0333f51aa50c0e4efb7d2a2d3e05a0543436f1e4871cfddf37e0a9e7f74f182'

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.paranoid = true
  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 10
  config.pepper = '57dfd8770b96697e264c15c226ddf3baab0bc98319a3603b115ccb61a9ea34d053224c06a79ef10b3d04a239497417a81ca007d3614c479873037a77514d64f6'

  config.remember_for = 2.weeks
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 8..128

  config.reset_password_within = 6.hours

  # The default HTTP method used to sign out a resource. Default is :delete.
  config.sign_out_via = [:delete, :get]
end
