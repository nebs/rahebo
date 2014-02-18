 #!/bin/bash
project_name=$1

# Initialize Rails project
rails new $project_name
cd $project_name

# Initialize git
git init
curl -o .gitignore https://raw.github.com/nebspetrovic/rahebo/master/lib/rahebo.gitignore

# Initialize Gemfile
curl -o Gemfile https://raw.github.com/nebspetrovic/rahebo/master/lib/Gemfile

# Remove the application layout since it will get overwritten by foundation
rm app/views/layouts/application.html.erb

# Setup bundle
bundle install
bundle exec rails g foundation:install
bundle exec rails g rspec:install
bundle exec rails g backbone:install

# Replace the application layout with a haml version
curl -o app/views/layouts/application.html.haml https://raw.github.com/nebspetrovic/rahebo/master/lib/application.html.haml

echo "---- RAHEBO COMPLETED SUCCESSFULLY ----"
