login: &login
  adapter: postgresql
  host: localhost
  port: 5432
  username: postgres
  password:

connection: &connection
  encoding: unicode
  pool: 5


development:
  database: typo_dev
  <<: *login
  <<: *connection

test:
  database: typo_tests
  <<: *login
  <<: *connection

production:
  database: typo
  <<: *login
  <<: *connection
