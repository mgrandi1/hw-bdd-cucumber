# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  regexp  =  (/#{e1}.*#{e2}/m)
  page.body.should =~  regexp
end


Then /I should (not )?see the following movies: (.*)/ do |negative, movie_list|
  movies = movie_list.split(", ")
  
  if negative
    movies.each{|movie| expect(page).not_to have_content(movie)}
  else
    movies.each{|movie| expect(page).to have_content(movie)}
  end
  
end  

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"  #  page.body is the   assert(page.body.index(e1) < page.body.index(e2))
When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  ratings = rating_list.split(" ")
  if uncheck
    ratings.each{|rating| uncheck("ratings_" + rating)}
  else
    ratings.each{|rating| check("ratings_" + rating)}
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  movies = Movie.pluck(:title)
  
  movies.each{|movie| expect(page).to have_content(movie)}
end
