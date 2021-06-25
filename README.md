# README

## Ruby version
- This project uses Ruby 2.7.3

## System dependencies
- Please ensure PostgreSQL is installed on your system.  PostgreSQL 13 was used for development.

## Database creation
- Use the following command to create the database:
```
  bundle exec rails db:create db:schema:load
```

## How to run the test suite
- To run the entire test suite:
```
  bundle exec rspec
```

## How to start the server in the development environment
```
  bundle exec rails s
```

## Endpoints
- Create a new product, price (in cents and in usd) and name are mandatory params, description is not mandatory but accepted
```
  POST /api/v1/products
```
- Get a single product, currency (one of usd, cad, gpb, eur) can be specified as a param
```
  GET /api/v1/products/:id
```
- List the most viewed products, currency (one of usd, cad, gpb, eur) can be specified as a param as well as limit (max number of products returned)
```
  GET /api/v1/products/most_viewed
```
- Delete a product, the product is no longer included in any API response, but remains in the database
```
  DELETE /api/v1/products/:id
```

## Other notes
- The price of a product is specified in cents so it can be stored as an integer in order to avoid cumulative rounding errors.
- To use the app, a CurrencyLayer API key is required.  It should be specified as CURRENCYLAYER_API_KEY in a .env file in the root directory of the app.