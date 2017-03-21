Given(/^the following movies exist:$/) do |table|
    table.hashes.each do |movie|
        Movie.create(movie)
    end
end

Then(/^the director of "([^"]*)" should be "([^"]*)"$/) do |title, director|
    visit movie_path(Movie.find_by(title: title))
    expect(page.body).to match(/Director:\s#{director}/)
end

Then /I should see "(.*)" before "(.*)"/ do |title1, title2|
  body = page.body
  location_of_title1_in_body = body.index(title1)
  location_of_title2_in_body = body.index(title2)
  loc1 = location_of_title1_in_body
  loc2 = location_of_title2_in_body
  if loc1 == nil || loc2 == nil
  	fail "One of both search parameters not found"
  else
  	expect(loc1<loc2).to eq true
  end
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  if uncheck == "un"
    rating_list.split(', ').each {|x| step %{I uncheck "ratings_#{x}"}}
  else
    rating_list.split(', ').each {|x| step %{I check "ratings_#{x}"}}
  end
end

Then /I should see all of the movies/ do
  rows = page.all('#movies tr').size - 1
  expect(rows).to eq Movie.count()
end