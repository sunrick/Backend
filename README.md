# API

## Overview

All access is over HTTPS, and access from the "https://radiant-oasis-8396.herokuapp.com" domain. All data is sent and received as JSON.

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
| full_name | string | full name of user to be created         |
| email      | string | email of user to be created              |


Example data successful response:

```
{
  "username": "testuser3",
  "full_name": "Test User3",
  "email": "test3@gmail.com",
  "access_token": "8f941eccc64db15"
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
    "Full_name can't be blank"
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
  "username": "testuser3",
  "access_token": "8f941eccc64db15a915"
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
  "full_name": "rsdffdasdf",
  "email": "whattt@sup.com",
  "home_address": null,
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



#### !ONLY SUPPORTS CHANGING HOME ADDRESS!

Example data successful response:

```json

{
  "username": "dsfasdf",
  "full_name": "rsdffdasdf",
  "email": "whattt@sup.com",
  "home_address": "3008 Coosawattee Drive GA 30312",
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
| destination    | string | final location that user wants to end up at             |

Example data successful response:

```json
{
  "id": 12,
  "trip": {
    "name": "hello",
    "distance": 71487,
    "duration": 4760
  },
  "route": {
    "origin": {
      "address": "115 Martin Luther King Junior Drive Northwest, Atlanta, GA 30303, USA",
      "latitude": 33.751724,
      "longitude": -84.3915205
    },
    "waypoints": [
      {
        "address": "215 Pryor Street Southwest, Atlanta, GA 30303, USA",
        "latitude": 33.7488366,
        "longitude": -84.393001
      },
      {
        "address": "1016 Princeton Walk Northeast, Marietta, GA 30068, USA",
        "latitude": 33.9756022,
        "longitude": -84.4284237
      },
      {
        "address": "3009 Oak Park Circle, Atlanta, GA 30324, USA",
        "latitude": 33.8259986,
        "longitude": -84.33533489999999
      }
    ],
    "destination": {
      "address": "Druid Hills, Atlanta, GA, USA",
      "latitude": 33.7744205,
      "longitude": -84.33970699999999
    }
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
    "Place3 can't be blank",
    "Destination can't be blank"
  ]
}
```

### Update a specific trip of a user

Access-Token:

Required.

Path:

`PUT 'user/trip/:id'`

Parameters:

| name       | type   | description                              |
|------------|--------|------------------------------------------|
| origin   | string | default address that a user wants to use          |
| place1 | string | first location user enters         |
| place2     | string | second location user enters              |
| place3     | string | third location user enters              |
| destination    | string | final location that user wants to end up at             |

Example data successful response:

```json
Response Status Code: 201

{
  "id": 12,
  "trip": {
    "name": "hello",
    "distance": 71487,
    "duration": 4760
  },
  "route": {
    "origin": {
      "address": "115 Martin Luther King Junior Drive Northwest, Atlanta, GA 30303, USA",
      "latitude": 33.751724,
      "longitude": -84.3915205
    },
    "waypoints": [
      {
        "address": "215 Pryor Street Southwest, Atlanta, GA 30303, USA",
        "latitude": 33.7488366,
        "longitude": -84.393001
      },
      {
        "address": "1016 Princeton Walk Northeast, Marietta, GA 30068, USA",
        "latitude": 33.9756022,
        "longitude": -84.4284237
      },
      {
        "address": "3009 Oak Park Circle, Atlanta, GA 30324, USA",
        "latitude": 33.8259986,
        "longitude": -84.33533489999999
      }
    ],
    "destination": {
      "address": "Druid Hills, Atlanta, GA, USA",
      "latitude": 33.7744205,
      "longitude": -84.33970699999999
    }
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
    "Place3 can't be blank",
    "Destination can't be blank"
  ]
}
```

### Show a specific trip for current user

Access-Token:

Required.

Path:

`GET '/user/trip/:id'`

Example data successful response:

```json
Response Status Code: 200

{
  "id": 12,
  "trip": {
    "name": "hello",
    "distance": 71487,
    "duration": 4760
  },
  "route": {
    "origin": {
      "address": "115 Martin Luther King Junior Drive Northwest, Atlanta, GA 30303, USA",
      "latitude": 33.751724,
      "longitude": -84.3915205
    },
    "waypoints": [
      {
        "address": "215 Pryor Street Southwest, Atlanta, GA 30303, USA",
        "latitude": 33.7488366,
        "longitude": -84.393001
      },
      {
        "address": "1016 Princeton Walk Northeast, Marietta, GA 30068, USA",
        "latitude": 33.9756022,
        "longitude": -84.4284237
      },
      {
        "address": "3009 Oak Park Circle, Atlanta, GA 30324, USA",
        "latitude": 33.8259986,
        "longitude": -84.33533489999999
      }
    ],
    "destination": {
      "address": "Druid Hills, Atlanta, GA, USA",
      "latitude": 33.7744205,
      "longitude": -84.33970699999999
    }
  }
}
```

### Show a list of trips for current user

Access-Token:

Required.

Path:

`GET '/user/trips'`

| name       | type   | description                              |
|------------|--------|------------------------------------------|
| page   | integer | defaults to 1, 25 results per page       |

Example data successful response:

```json
Response Data Code: 200

[
  {
    "id": 1,
    "trip": {
      "name": "hello",
      "created_at": "2015-06-27T20:54:53.345Z"
    }
  },
  {
    "id": 2,
    "trip": {
      "name": "hello",
      "created_at": "2015-06-27T20:57:15.052Z"
    }
  },
  {
    "id": 3,
    "trip": {
      "name": "hello",
      "created_at": "2015-06-27T22:07:00.162Z"
    }
  }
]
```
