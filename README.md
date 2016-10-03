# annual-staffing-request

A Rails application for submitting staffing requests as part of the library budgeting process.


## Quick Start

Requires:

* Ruby 2.2.4
* Bundler

### Setup
1) Checkout the code and install the dependencies:

```
> git clone git@github.com:umd-lib/annual-staffing-request
> cd annual-staffing-request
> bundle install --without production
```

2) Set up the database:

```
> rake db:reset
```

3) (Optional) Populate database with sample data:

```
> rake db:reset_with_sample_data
```

### Adding an Admin User and Roles

4) The application uses CAS authentication to only allow known users to log in. The seed data for the database does not contain any users. Run the following Rake task to add a user:

```
> rake 'db:add_cas_user[<CAS DIRECTORY ID>,<FULL NAME>]'
```
and replacing the "\<CAS DIRECTORY ID>" and "\<FULL NAME>" with valid user information. For example, to add "John Smith" with a CAS Directory ID of "jsmith":

```
> rake 'db:add_cas_user[jsmith, John Smith]'
```

5) Users also need a role. Since any user with an Admin role can add additional role permissions through the web application, you typically only need to add an "Admin" user to start.

The format of the Rake task to add an "admin" user is:

```
> rake 'db:add_role[<CAS DIRECTORY ID>,admin]'
```
where "\<CAS DIRECTORY ID>" is the CAS Directory ID of a known user. For example, to create an "Admin" role for the "jsmith" user:

```
> rake 'db:add_role[jsmith, admin]'
```

Note: In a production environment, you will likely need to use "bundle exec" and specify the RAILS_ENV environment, i.e.:

```
bundle exec rake 'db:add_role[jsmith, admin]' RAILS_ENV=production
```

See [docs/AuthNZ.md](docs/AuthNZ.md) for more information about authentication and authorization.

See [docs/RakeTasks.md](docs/RakeTasks.md) for additional information about the "db:add_cas_user" and "db:add_role" Rake tasks, including how to add other types of roles to users.

### Run the web application

5) To run the web application:

```
> rails server
```

## Production Environment Configuration

Requires:

* Postgres client to be installed (on RedHat, the "postgresql" and 
"postgresql-devel" packages)

The application uses the "dotenv" gem to configure the production environment.
The gem expects a ".env" file in the root directory to contain the environment
variables that are provided to Ruby. A sample "env_example" file has been
provided to assist with this process. Simply copy the "env_example" file to
".env" and fill out the parameters as appropriate.

The configured .env file should _not_ be checked into the Git repository, as it
contains credential information.
