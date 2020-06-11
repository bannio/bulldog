# transformations used in cucumber steps

# CAPTURE_A_NUMBER = Transform /^(\d+\.*\d*)$/ do |number|
#   number.to_f
# end

ParameterType(
  name: 'number',
  regexp: /\d+\.*\d*/,
  transformer: -> (number) { number.to_f }
)
# This constant should be redundant but may capture any missed instances
CAPTURE_A_NUMBER = /\d+\.*\d*/