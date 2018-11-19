# Reservation Booking App

Basic restaurant reservation application, using Rails 5 API with simple Rspec tests

---

## Setup Requirements

To run this project in local development, you need:
- Ruby 2.5.1

clone the repo and run:

```bin/setup```

The command will install the dependencies, setup `database.yml` , create and migrate the database.

---

## Postman Collection

[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/a00ce20d6c77e33e3253)

---

## Details

### Roles

Application have 3 types of users:

- **Admin**: have access to all data
- **Manager**: Restaurant owner, can create manage his own restuarnat reservations
- **Guest**: can book a reservation and manager there own reservations

### Code

- All CRUD controllers are inhereting from [BaseController](app/controllers/v1/base_controller.rb) as most of the logic are same
- Same API resource can be accessed by all roles, and data will be scoped by the user role
- All roles scopes and permissions are in [Power](app/models/power.rb) class
