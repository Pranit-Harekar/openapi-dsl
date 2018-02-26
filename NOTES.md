# API Specification

An informal specification for the Bookmarker RESTful API.

**N.B.** *Requests and responses use the [JSON API](http://jsonapi.org/) specification.*

**Resources**

- Users
  - POST /users - Create a new user
  - GET /users - Get all users
  - DELETE /users/:id - Delete a user
  - GET /user - Get the currently logged in user
- Session
  - POST /session - Login
  - DELETE /session - Logout
- Bookmarks
  - POST /user/bookmarks - Create a new bookmark for the currently logged in user
  - PATCH /user/bookmarks/:id - Update a bookmark for the currently logged in user
  - DELETE /user/bookmarks/:id - Delete a bookmark for the currently logged in user
  - GET /bookmarks - Get all bookmarks
  - GET /bookmarks/:id - Get a bookmark
  - PATCH /bookmarks/:id - Update a bookmark
  - DELETE /bookmarks/:id - Delete a bookmark
- Sites
  - GET /sites - Get all sites
  - GET /sites/:id - Get a site
- Tasks
  - GET /tasks/:id - Get a task

## Users

### POST /users

Create a new user.

**Request**

```js
// POST /users

{
  "data": {
    "type": "user",
    "attributes": {
      "display_name": "Dwayne", // optional
      "email": "me@dwaynecrooks.com",
      "password": "password",
      "password_confirmation": "password"
    }
  }
}
```

**Responses**

```js
// 201 Created
// Location: https://api.bookmarker.com/users/1

{
  "data": {
    "type": "user",
    "id": 1,
    "attributes": {
      "display_name": "Dwayne",
      "email": "me@dwaynecrooks.com"
    }
  },
  "meta": {
    "token": "jwt"
  }
}
```


```js
// 400 Bad Request

{
  "errors": [
    // Some of the possibilities
    {
      "detail": "The email is required.",
      "source": {
        "pointer": "/data/attributes/email"
      }
    },
    {
      "detail": "The email is already taken."
      "source": {
        "pointer": "/data/attributes/email"
      }
    },
    {
      "detail": "The password is required.",
      "source": {
        "pointer": "/data/attributes/password"
      }
    },
    {
      "detail": "The password is invalid.",
      "source": {
        "pointer": "/data/attributes/password"
      }
    },
    {
      "detail": "The password and password confirmation do not match.",
      "source": {
        "pointer": "/data/attributes/password_confirmation"
      }
    }
  ]
}
```

### GET /users

Get all users. You must be logged in with the admin role.

**Request**

```js
// GET /users
// Authorization: jwt with the admin role
```

**Responses**

```js
// 200 OK

{
  "data": [
    {
      "type": "user",
      "id": 1,
      "attributes": {
        "display_name": "Dwayne",
        "email": "me@dwaynecrooks.com"
      }
    },
    {
      "type": "user",
      "id": 2,
      "attributes": {
        "display_name": "John",
        "email": "john@example.com"
      }
    }
  ],
  "links": {
    "self": "https://api.bookmarker.com/users"
  }
}
```

```js
// 401 Unauthorized

{
  "errors": [
    { "detail": "You must be logged in to get all users." }
  ]
}
```

```js
// 403 Forbidden

{
  "errors": [
    { "detail": "You must have the admin role to get all users." }
  ]
}
```

### DELETE /users/:id

Delete a user. You must be logged in with the admin role.

**Request**

```js
// DELETE /users/1
// Authorization: jwt with the admin role
```

**Responses**

```js
// 204 No Content
```

```js
// 401 Unauthorized

{
  "errors": [
    { "detail": "You must be logged in to delete a user." }
  ]
}
```

```js
// 403 Forbidden

{
  "errors": [
    { "detail": "You must have the admin role to delete a user." }
  ]
}
```

### GET /user

Get the currently logged in user. You must be logged in.

**Request**

```js
// GET /user
// Authorization: jwt
```

**Responses**

```js
// 200 OK

{
  "data": {
    "type": "user",
    "id": 1,
    "attributes": {
      "display_name": "Dwayne",
      "email": "me@dwaynecrooks.com"
    }
  },
  "links": {
    "self": "https://api.bookmarker.com/user"
  }
}
```

```js
// 401 Unauthorized

{
  "errors": [
    { "detail": "You must be logged in to access your user details." }
  ]
}
```

## Session

### POST /session

Login.

**Request**

```js
// POST /session

{
  "data": {
    "type": "session",
    "attributes": {
      "email": "me@dwaynecrooks.com",
      "password": "password"
    }
  }
}
```

**Responses**

```js
// 201 Created

{
  "data": {
    "type": "session",
    "attributes": {
      "token": "a jwt"
    }
  }
}
```

```js
// 400 Bad Request

{
  "errors": [
    // Some of the possibilities
    {
      "detail": "No user exists with the given email.",
      "source": {
        "pointer": "/data/attributes/email"
      }
    },
    {
      "detail": "The password is incorrect."
      "source": {
        "pointer": "/data/attributes/password"
      }
    }
  ]
}
```

### DELETE /session

Logout.

**Request**

```js
// DELETE /session
// Authorization: jwt
```

**Responses**

```js
// 204 No Content
```

## Bookmarks

*WIP*

## Sites

*WIP*

## Tasks

*WIP*
