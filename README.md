# Installation and running this solution

### DEPENDENCIES 
* Rails 6.2
* Ruby 3.0.1
* Nodejs >= 12.0.0
* Postgres > 9.0.0

### INSTALLATION
* `SET:` ENV variables for Postgres in database.yml
* **FROM DIRECTORY**
* `RUN:` rake db:create
* `RUN:` rake db:migrate
* `RUN:` rake db:seed
* `RUN:` bundle install

### USAGE
* **FROM DIRECTORY**
* `RUN:` rails s
* `OPEN:` browser
* `VISIT:` localhost:3000

### TESTING
* **FROM DIRECTORY**
* `RUN:` rails test test/system/nfl_players_test.rb

### TO DO
* Add auto complete
* Add onHover with long text to table headings
* Refactor NFL controller
* Refactor tests
