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

### Adding Users and Roles

4) The application use CAS authentication to only allow known users to log in. The seed data for the database does not contain any users. Run the following Rake task to add a user:

```
> rake 'db:add_cas_user[<CAS DIRECTORY ID>,<FULL NAME>]'
```
and replacing the "\<CAS DIRECTORY ID>" and "\<FULL NAME>" with valid user information. For example, to add "John Smith" with a CAS Directory ID of "jsmith":

```
> rake 'db:add_cas_user[jsmith, John Smith]'
```

5) Users also need a role, of which there are 4 types:

* Admin
* Division
* Department
* Unit

Any existing user can be added to a role using the following Rake task:

```
> rake 'db:add_role[<CAS DIRECTORY ID>,<ROLE TYPE>,<ORG CODE>]'
```
and replacing the "\<CAS DIRECTORY ID>" with the CAS Directory ID of a known user, provide a \<ROLE TYPE> of "admin", "division", "department", or "unit", and an \<ORG CODE> corresponding to the role type (optional for "admin" roles). For example, to create an "Admin" role for the "jsmith" user:

```
rake 'db:add_cas_user[jsmith, admin]'
```

To give a Department role to "jsmith" for the "SSDR" department:

```
rake 'db:add_cas_user[jsmith, department, SSDR]'
```

Note: Any user with an Admin role can add additional role permissions through the web application, so typically you only need to add an "Admin" user to start.

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
