# secure_headers
# SecureHeaders::Configuration.default do |config|
#   config.cookies = {
#     secure: true, # mark all cookies as "Secure"
#     httponly: true, # mark all cookies as "HttpOnly"
#     samesite: {
#       lax: true # mark all cookies as SameSite=lax
#     }
#   }
#   config.csp = {
#     # "meta" values. these will shape the header, but the values are not included in the header.
#     # preserve_schemes: true, # default: false. Schemes are removed from host sources to save bytes and discourage mixed content.
#     # disable_nonce_backwards_compatibility: true, # default: false. If false, `unsafe-inline` will be added automatically when using nonces. If true, it won't. See #403 for why you'd want this.

#     # directive values: these values will directly translate into source directives
#     default_src: %w('self' https:),
#     # default_src: %w('none'),
#     # base_uri: %w('self'),
#     # block_all_mixed_content: true, # see http://www.w3.org/TR/mixed-content/
#     # child_src: %w('self'), # if child-src isn't supported, the value for frame-src will be set.
#     # connect_src: %w(wss:),
#     font_src: %w('self' https: data:), ##
#     # form_action: %w('self' github.com),
#     # frame_ancestors: %w('none'),
#     img_src: %w('self' https: data:), ##
#     # manifest_src: %w('self'),
#     # media_src: %w(utoob.com),
#     object_src: %w('none'),
#     # sandbox: true, # true and [] will set a maximally restrictive setting
#     # plugin_types: %w(application/x-shockwave-flash),
#     script_src: %w('self' https: 'unsafe-inline'),
#     style_src: %w('self' https: 'unsafe-inline')
#     # worker_src: %w('self'),
#     # upgrade_insecure_requests: true, # see https://www.w3.org/TR/upgrade-insecure-requests/
#     # report_uri: %w(https://report-uri.io/example-csp)
#   }
# end

# Defaults used by secure_headers. Here for reference:

# Content-Security-Policy:
# default-src 'self' https:;
# font-src 'self' https: data:;
# img-src 'self' https: data:;
# object-src 'none';
# script-src https:;
# style-src 'self' https: 'unsafe-inline'

# Defaults suggested by Rails:

# Rails.application.config.content_security_policy do |policy|
#   policy.default_src :self, :https
#   policy.font_src    :self, :https, :data
#   policy.img_src     :self, :https, :data
#   policy.object_src  :none
#   policy.script_src  :self, :https
#   policy.style_src   :self, :https