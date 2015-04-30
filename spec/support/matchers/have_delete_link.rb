RSpec::Matchers.define :have_delete_link do |*expected|
  match do |actual|
    actual.has_link?(*expected) && find_link(*expected)['data-method'] == 'delete'
  end

  failure_message do |actual|
    "expected that page has delete link #{expected} in #{actual.text}"
  end

  failure_message_when_negated do |actual|
    "expected that page does not have delete link #{expected} in #{actual.text}"
  end
end