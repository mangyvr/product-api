# README

* Ruby version
- This project uses Ruby 2.7.3

* System dependencies
- Please ensure PostgreSQL is installed on your system.  PostgreSQL 13 was used for development.

* Database creation
- Use the following command to create the database:
  bundle exec db:create db:schema:load

* How to run the test suite
- To run the entire test suite:
  bundle exec rspec

* How to start the server in the development environment
  bundle exec rails s

* Other notes
- The price of a product is specified in cents so it can be stored as an integer in order to avoid cumulative rounding errors.