RSpec::Matchers.define :have_flash_message do |*expected|
  match do |actual|
    actual.has_selector? '.alert'
  end

  failure_message do |actual|
    "expected that page has flash message in\n#{actual.text}"
  end

  failure_message_when_negated do |actual|
    "expected that page does not have flash message in\n#{actual.text}"
  end
end

RSpec::Matchers.define_negated_matcher :have_no_flash_message, :have_flash_message