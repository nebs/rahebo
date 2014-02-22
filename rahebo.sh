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
rm app/views/layouts/application.html.erb
curl -o app/views/layouts/application.html.haml https://raw.github.com/nebspetrovic/rahebo/master/lib/application.html.haml

# Copy over a postgres database configuration
curl -o config/database.yml https://raw.github.com/nebspetrovic/rahebo/master/lib/database.yml

# Add the project name in the database config
sed -i "" "s/PROJECT_NAME/$project_name/g" config/database.yml

# Create a postgres user for this project
createuser -s -r $project_name

# Create postgres test and dev databases
createdb ${project_name}_test
createdb ${project_name}_development

echo "---- RAHEBO COMPLETED SUCCESSFULLY ----"
