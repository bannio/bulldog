# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |policy|
  policy.default_src :self
  policy.font_src    :self, :data, 'vjs.zencdn.net'
  policy.img_src     :self, :data
  policy.media_src   :self, :data, 's3.amazonaws.com'
  policy.object_src  :none
  policy.script_src  :self, "vjs.zencdn.net 'unsafe-inline' 'unsafe-eval'"
  policy.style_src   :self, "vjs.zencdn.net 'unsafe-inline'"

  # Specify URI for violation reports
  # policy.report_uri "/csp-violation-report-endpoint"
end

# If you are using UJS then enable automatic nonce generation
# Rails.application.config.content_security_policy_nonce_generator = -> request { SecureRandom.base64(16) }

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
