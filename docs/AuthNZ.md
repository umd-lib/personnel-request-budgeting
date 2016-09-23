<!--
# @title Authentication and Authorization
-->

# Authentication and Authorization

## Authentication

The application uses CAS to perform user authentication, via the "rubycas-client" gem.

## Authorization

The application uses the "pundit" gem to both control what a user can do, and also, through the use of Pundit's "scope" mechanism, control the records a user may see.

Permissions are controlled by "roles". Available roles, with their associated permissions and scope are summarized in the following table:

| Role       | Create          | Read              | Update          | Delete          |
| ---------- | --------------- | ----------------- | --------------- | --------------- |
| Admin      | Yes             | Yes               | Yes             | Yes             |
| Division   | Division only   | Yes (all records) | Division only   | Division only   |
| Department | Department only | Department only   | Department only | Department only |
| Unit       | Unit only       | Unit only         | Unit only       | Unit only       |

Users with an "Admin" role can perform any operation, and will always see all personnel requests. An "Admin" user also has access to application-specific operations such as adding/removing users and roles, reporting, and impersonation.

A user with a "Division" role can see all the personnel requests, but can only create, update, or delete personnel requests within their division.

A user may have multiple roles (for example, a Division role and a Department role), in which case they have access to all the records each individual role would give them.

## Role Cutoffs

Admin users can specify individual "role cutoff" dates for the Division, Department, and Unit roles. On the specified date, the role will no longer have "Create", "Update", or "Delete" permission, but will still have "Read" permission, i.e., users with that role will be able to see personnel requests, but not be able to modify them.

If a user has multiple roles, they will still have permission to perform operations on roles not subject to a cutoff. For example, if the "Unit" cutoff date has passed, a user with both a Department and Unit role will still be able to modify personnel requests available due to their "Department" role, but not those available because of their "Unit" role.

Admin users are never subject to role cutoffs.

## Impersonation

Admin users have the ability to "impersonate" other users (except themselves or other Admin users). This is primarily intended to enable troubleshooting and verification of user role setups.



