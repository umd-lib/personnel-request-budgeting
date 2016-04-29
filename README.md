# annual-staffing-request

A Rails application for submitting staffing requests as part of the library budgeting process.


## Quick Start

Requires:

* Ruby 2.2.4
* Bundler

1) Setup:

```
> git clone git@github.com:umd-lib/annual-staffing-request
> cd annual-staffing-request
> bundle install --without production
```

2) (Optional) Populate database with sample data:

```
> rake db:reset_with_sample_data
```

3) Run:

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
