# transformations used in cucumber steps

CAPTURE_A_NUMBER = Transform /^(\d+\.*\d*)$/ do |number|
  number.to_f
end