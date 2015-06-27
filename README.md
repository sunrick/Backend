# API

## Overview

All access is over HTTPS, and access from the "https://url" domain. All data is sent and received as JSON.

## Access Token

Assume that every request requires an access token unless stated otherwise. The access token must be provided in the header.

To do this make sure you set 'Access-Token' equal to the user's access token in every required request.

```
['Access-Token'] = 'f16395873f4bcee7ef5d46e531b9f659'
```

## Sign up, Login, User profile and Delete user

### New user registration

Access-Token:

Not required.

Path:

`POST '/users/register'`

Parameters:

| name       | type   | description                              |
|------------|--------|------------------------------------------|
| username   | string | username for user to be created          |
| password   | string | password has to be at least 8 characters |
| fullname | string | full name of user to be created         |
| email      | string | email of user to be created              |


Example data successful response:

```json
Response Status Code: 201

{
  "username": "whatever",
  "access_token": "f16395873f4bcee7ef5d46e531b9f659f16395873f4bcee7ef5d46e531b9f659",
  "fullname": "John",
  "email": "johndoe@gmail.com",
  "home_address": "3008 Coosawattee Drive GA 30312",
  "created_at": "2015-06-19T15:51:02.488Z",
  "updated_at": "2015-06-19T15:51:02.488Z"
}
```

Example data failure response:

```json
Response Status Code: 422

{
  "errors": [
    "Password can't be blank",
    "Email can't be blank",
    "Email is not a valid email.",
    "User name can't be blank",
    "Fullname can't be blank"
  ]
}

```

### User login

Access-Token:

Not required.

Path:

`POST '/users/login'`

Parameters:

| name     | type   | description                                                 |
|----------|--------|-------------------------------------------------------------|
| username | string | username for the user you want get authentication key for   |
| password | string | password for the user you want get authentication token for |

Example data successful response:

```json
Response Status Code: 200

{
  "username": "whatever",
  "access_token": "f16395873f4bcee7ef5d46e531b9f659"
}
```

Example data failure response:

```json
Response Status Code: 422

{
  "message":"The username or password you supplied is incorrect."
}
```

### Get current user profile

Access-Token:

Required.

Path:

`GET '/user/profile'`

Example data successful response:

```json

{
  "username": "dsfasdf",
  "fullname": "rsdffdasdf",
  "email": "whattt@sup.com",
  "home_address": "3008 Coosawattee Drive GA 30312",
  "created_at": "2015-06-19T15:51:02.488Z"
  "updated_at": "2015-06-19T15:51:02.488Z"
}
```

Example data failure response:

```json
Response Status Code: 404

{
  "message": "There is no user to display."
}
```

### Update current user profile

Access-Token:

Required.

Path:

`PUT '/user/profile'`

Parameters:

| name       | type   | description                              |
|------------|--------|------------------------------------------|
| home_address   | string | default address that a user wants to use          |
| fullname | string | full name of user to be changed         |
| email      | string | email of user to be changed              |

#### !DOES NOT SUPPORT CHANGING PASSWORD!

Example data successful response:

```json

{
  "username": "dsfasdf",
  "fullname": "rsdffdasdf",
  "email": "whattt@sup.com",
  "home_address": "3008 Coosawattee Drive GA 30312",
  "created_at": "2015-06-19T15:51:02.488Z"
  "updated_at": "2015-06-19T15:51:02.488Z"
}
```

Example data failure response:

```json
Response Status Code: 404

{
  "message": "There is no user to display."
}
```

## Create and view trips

### !!!WORK IN PROGRESS!!! MIGHT CHANGE !!!

Places are ordered from first to last. This means a user should travel

### Create a new trip

Access-Token:

Required.

Path:

`POST '/trips/new'`

Parameters:

| name       | type   | description                              |
|------------|--------|------------------------------------------|
| origin   | string | default address that a user wants to use          |
| place1 | string | first location user enters         |
| place2     | string | second location user enters              |
| place3     | string | third location user enters              |

Example data successful response:

```json
{
  "id": "231",
  "trip_info" : {
    "name": "House hunting",
    "duration": "1h30mins",
    "distance": "44 miles",
    "created_at": "2015-06-19T15:51:02.488Z",
    "updated_at": "2015-06-19T15:51:02.488Z"
  },
  "origin": {
    "address": "3008 Coosawattee Drive GA 30312"
  },
  "places": {
    [
      {
        "address": "3008 Somewhere Drive GA 30312"
      },
      {
        "address": "3008 Whocares Drive GA 30312"
      },
      {
        "address": "3008 Sverige Drive GA 30312"
      }
    ]
  }
}
```

#### !!!! TO BE DETERMINED !!!!
Example data failure response:

```json
Response Status Code: 422

{
  "errors": [
    "Origin can't be blank",
    "Place1 can't be blank",
    "Place2 can't be blank",
    "Place3 can't be blank"
  ]
}
```

### Show a specific trip for current user

Access-Token:

Required.

Path:

`GET '/trip/:id'`

Example data successful response:

```json
{
  "id": "231",
  "trip_info" : {
    "name": "House hunting",
    "duration": "1h30mins",
    "distance": "44 miles",
    "created_at": "2015-06-19T15:51:02.488Z",
    "updated_at": "2015-06-19T15:51:02.488Z"
  },
  "origin": {
    "address": "3008 Coosawattee Drive GA 30312"
  },
  "places": {
    [
      {
        "address": "3008 Somewhere Drive GA 30312"
      },
      {
        "address": "3008 Whocares Drive GA 30312"
      },
      {
        "address": "3008 Sverige Drive GA 30312"
      }
    ]
  }
}
```

### Show a list of trips for current user

Access-Token:

Required.

Path:

`GET '/trips'`

| name       | type   | description                              |
|------------|--------|------------------------------------------|
| page   | integer | defaults to 1, 25 results per page       |

Example data successful response:

```json
[
{
  "id": "231",
  "trip_info" : {
    "name": "House hunting",
    "duration": "1h30mins",
    "distance": "44 miles",
    "created_at": "2015-06-19T15:51:02.488Z",
    "updated_at": "2015-06-19T15:51:02.488Z"
  },
  "origin": {
    "address": "3008 Coosawattee Drive GA 30312"
  },
  "places": {
    [
      {
        "address": "3008 Somewhere Drive GA 30312"
      },
      {
        "address": "3008 Whocares Drive GA 30312"
      },
      {
        "address": "3008 Sverige Drive GA 30312"
      }
    ]
  }
},
{
  "id": "232",
  "trip_info" : {
    "name": "Grocery stores",
    "duration": "0h32mins",
    "distance": "12 miles",
    "created_at": "2015-06-19T15:51:02.488Z",
    "updated_at": "2015-06-19T15:51:02.488Z"
  },
  "origin": {
    "address": "3008 Coosawattee Drive GA 30312"
  },
  "places": {
    [
      {
        "address": "3008 Somewhere Drive GA 30312"
      },
      {
        "address": "3008 Whocares Drive GA 30312"
      },
      {
        "address": "3008 Sverige Drive GA 30312"
      }
    ]
  }
}
]
```
