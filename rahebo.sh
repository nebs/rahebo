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

# Create a basic welcome home page
bundle exec rails g controller Welcome index

# Replace the application layout with a haml version
rm app/views/layouts/application.html.erb
curl -o app/views/layouts/application.html.haml https://raw.github.com/nebspetrovic/rahebo/master/lib/application.html.haml

# Update the title placeholder in the applicationi layout
sed -i "" "s/YOUR_TITLE_HERE/$project_name/g" app/views/layouts/application.html.haml

# Copy over a postgres database configuration
curl -o config/database.yml https://raw.github.com/nebspetrovic/rahebo/master/lib/database.yml

# Add the project name in the database config
sed -i "" "s/PROJECT_NAME/$project_name/g" config/database.yml

# Create a postgres user for this project
createuser -s -r $project_name

# Create postgres test and dev databases
createdb ${project_name}_test
createdb ${project_name}_development

# Create a User model
bundle exec rails g model User provider uid name oauth_token oauth_expires_at:datetime

# Copy over a pre-configured user model
curl -o app/models/user.rb https://raw.github.com/nebspetrovic/rahebo/master/lib/user.rb

# Copy over a pre-configured application controller
curl -o app/controllers/application_controller.rb https://raw.github.com/nebspetrovic/rahebo/master/lib/application_controller.rb

# Create a sessions controller
bundle exec rails g controller Sessions create destroy

# Copy over a pre-configured sessions controller
curl -o app/controllers/sessions_controller.rb https://raw.github.com/nebspetrovic/rahebo/master/lib/sessions_controller.rb

# Copy over the pre-configured routes file
curl -o config/routes.rb https://raw.github.com/nebspetrovic/rahebo/master/lib/routes.rb

# Add the project name in the routes file
sed -i "" "s/PROJECT_NAME/$project_name/g" config/routes.rb

# Copy over the preconfigured omniauth initializer
curl -o config/initializers/omniauth.rb https://raw.github.com/nebspetrovic/rahebo/master/lib/omniauth.rb

# Run migrations
bundle exec rake db:migrate db:test:prepare

echo "---- RAHEBO COMPLETED SUCCESSFULLY ----"
