include Test::Unit::Assertions
require File.dirname(__FILE__) + '/../../lib/jira-wsdl'


Given /^I create instantiation of Jira$/ do
  puts 'Creating Jira Object'
  @jira= JiraWsdl.new('jira.atlassian.com', 'tiago.l.nobre+test', '123qwe')
end

Then /^I have a login token to access all the functions$/ do
  puts @jira.token
  assert(!@jira.token.nil?, 'Token is empty')
end

Then(/^I can get the versions of the project with the key "([^"]*)"$/) do |key|
  result, error = @jira.get_version key
  assert_equal(true, result, error)
  assert(!@jira.actual_version.nil?, 'Can\'t get actual version')
  puts "Actual version: #{@jira.actual_version}"
  assert(!@jira.actual_version.nil?, 'Can\'t get next version')
  puts "Next version: #{@jira.next_version}"

end

Then(/^I can get the tickets for the "([^"]*)" project, next version with status "([^"]*)"$/) do |project, status|
  @jira.get_version project
  assert(!@jira.next_version.nil?, 'Can\'t get next version')
  puts "Next version: #{@jira.next_version}"

  version = @jira.next_version
  tickets = @jira.get_jira_tickets(status, project, version)

  puts tickets
  assert(!tickets.empty?, 'Tickets are empty')
end

Then(/^I can get all versions for the "([^"]*)" project$/) do |project|
  @jira.get_version project
  assert(!@jira.all_versions.empty?, 'Can\'t get next version')
  puts "All version: #{@jira.all_versions}"
end
Then(/^I logout from Jira$/) do
  @jira.logout
end

Then(/^I get a list of permitted operations$/) do
  puts @jira.list_operations
end

Then(/^I check that the project "([^"]*)" existence is "([^"]*)"$/) do |project, boolean|
  result, error = @jira.check_project project
  assert_equal(result.to_s, boolean, error)
end

Then(/^I query by hash (.*)$/) do |query|
  jqlquery_result = @jira.query_by_hash(eval(query))
  assert_equal(true, jqlquery_result.success, jqlquery_result.tickets )
  puts jqlquery_result.tickets
  assert(!jqlquery_result.tickets.empty?, 'Tickets are empty')
end

Then(/^I jql query jira (.*)$/) do |string|
  jqlquery_result = @jira.jqlquery(string)
  assert_equal(true, jqlquery_result.success, jqlquery_result.tickets )
  puts jqlquery_result.tickets
  assert(!jqlquery_result.tickets.empty?, 'Tickets are empty')
end