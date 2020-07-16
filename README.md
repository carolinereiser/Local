
# Local

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
A social media app where users can post and share their favorite sites, restaurants, attractions, and places all around the world.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Social Media/Travel
- **Mobile:** Map, location, camera feature/pictures, push
- **Story:** A lot of times when travelling it is hard to figure out what to do, with this app you can see recommendations from other people (friends, celebrities, and randoms) without falling into tourist traps.
- **Market:** Anybody who travels and/or likes to document cool finds/places that they've been to.
- **Habit:** Scrolling through places where others have been is addicting. Any time somebody wants to find something new to do, they can log onto the app.
- **Scope:** The app works better when more people are on it. However, if I can get just 5 people to go on it from a certain area, then it would work nicely. 

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Login/logout functionality
* Profile page where the user can see:
    * profile picture/background image
    * edit profile button
    * number of people following, number of followers, number of countries they've visited, number of cities they've visited
    * their posts that they've posted
* User can edit their profile 
* A timeline where a user can see the posts from every user (will be later changed to only users the person follows)
    * When a user clicks on the profile pic of the person who posted, the user is taken to their profile
* User can put in their address and become a "certified local." Whenever they post a place within a 20 mile radius of their address, the post will show to other users that it was posted by a "certified local"
* Functionality to add a place (city or country) that they've been to, this is what shows up on the users profile
    * The "certified local" posts are automatically a users place and posts within the radius are automatically added to that place. However, a user can still make separate places within the 20 mile radius.
    * Required to add place: a single picture and a location
* Functionality to add a favorite spot inside of a place, this is what shows up on other users' timeline
    * Required to add spot: at least one picture and a location
    * Optional to add spot: a description, up to 10 pictures
* User can search places and see spots from those places
* User can search for other users

**Optional Nice-to-have Stories**

* User can follow other users
* Timeline just shows posts from users that the current user follows
* User have a map on their profile mapping all of the places that they've posted about
* User can see a map of spots all of the people they follow have been to
* Users can like other users posts
* Users can save other users posts, these saved posts show up on a user's profile
* Implement a button where a user can select a mile radius from their current location. When they press that button and be given a random spot to go to within that radius that one of the people they follow have posted. If there are no spots within that radius, the user is told to increase the mile radius
* Users can share posts
* Users can make their account private
* When a user searches a place, only spots from public accounts and people they follow come up
* When a user searches a place, the most liked/shared spots are displayed first
* Notification tab where a user can see if other users liked their post

### 2. Screen Archetypes

* [list first screen here]
   * [list associated required story here]
   * ...
* [list second screen here]
   * [list associated required story here]
   * ...

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* [fill out your first tab]
* [fill out your second tab]
* [fill out your third tab]

**Flow Navigation** (Screen to Screen)

* [list first screen here]
   * [list screen navigation here]
   * ...
* [list second screen here]
   * [list screen navigation here]
   * ...

## Wireframes

<img src="https://user-images.githubusercontent.com/49702878/87459914-e2578280-c5c0-11ea-8b5a-920c2ff20b56.png" width=639>
<img width="417" src="https://user-images.githubusercontent.com/49702878/87459945-ee434480-c5c0-11ea-9f95-e26d93bcce58.png">





## Schema 
[This section will be completed in Unit 9]
### Models
#### User
   | Property              | Type     | Description |
   | --------------------- | -------- | ------------|
   | objectID              | String   | unique id for the user (default)|
   | username              | String   | Username for user |
   | email                 | String   | email associated with user |
   | password              | String   | email associated with user |
   | name                  | String   | name that appears on profile |
   | profilePic            | File     | picture that user selects as profile |
   | backgroundPic         | File     | picture that user selects as background |
   | followerCount         | Number   | total number of followers |
   | followingCount        | Number   | Total number of following |
   | countriesVisitedCount | Number   | Total number of countries visited |
   | citiesVisitedCount    | Number   | Total number of cities visited |
   | lat                   | Float    | Latitutde of user home address |
   | lng                   | Float    | Longitude of user home address |
   | placeID               | String   | placeID of user home address |
   | isPublic              | Bool     | whether or not the user is a public account |
   | createdAt             | DateTime | date when user is created (default field) |
   | updatedAt             | DateTime | date when user is last updated (default field) |
   
#### Places

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the place (default field) |
   | user          | Pointer to User | user who posted the place |
   | name          | String   | name of the place |
   | placeId       | String   | place id from google Places api |
   | lat           | Float    | latitude of place |
   | lng           | Float    | longitude of place |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |
   
#### Spots
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the spot (default field) |
   | name          | String   | name of the spot |
   | placeId       | String   | place id from google Places api |
   | lat           | Float    | latitude of place |
   | lng           | Float    | longitude of place |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |
  
#### Posts
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user post (default field) |
   | author        | Pointer to User| image author |
   | place         | Pointer to Place | place that the post is of |
   | spot          | Pointer to Spot | spot that the post is of |
   | images        | Array of Files  | image that user posts |
   | caption       | String   | image caption by author |
   | savedCount    | Number   | number of saves to a post |
   | likesCount    | Number   | number of likes for the post |
   | isCertified   | Bool     | if was posted by a certified local or not |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |


#### SpotsToPlaces
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the relationship (default field) |
   | user          | Pointer to User | User who posted the spot to the place |
   | spot          | Pointer to Spot | spot in relationship  |
   | place         | Pointer to Place| place in relationship |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |
   
#### Liked
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the saved (default field) |
   | user          | Pointer to User| person who liked the post |
   | author        | Pointer to User| person who posted the post |
   | post          | Pointer to Post| post that user saved |
   | createdAt     | DateTime | date when save happens is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |

#### Saved
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the saved (default field) |
   | user          | Pointer to User| person who saved the post |
   | post          | Pointer to Post| post that user saved |
   | createdAt     | DateTime | date when save happens is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |
   
#### FollowingFollower
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the following/follower (default field) |
   | user          | Pointer to User| person is being followed |
   | follower      | Pointer to User| person who is following the user |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |

### Networking
* Timeline Feed Screen
   * (Read/GET) Query all posts of the users logged in user follows
   * (Create/POST) Create a new like on a post
   * (Delete) Delete existing like
   * (Create/POST) Create a new save on a post
   * (Delete) Delete existing save
* World Map Screen
   * (Read/GET) Query all spots of the users logged in user follows
* Search Screen
   * (Read/GET) Query the Spots to Places and display all spots in the searched place
* Post Screen
   * (Create/POST) Create a new post object 
* Notifications Screen
   * (Read/GET) Query Liked to see the posts that the user has posted that others have liked
* Profile Screen
   * (Read/GET) Query logged in user object
   * (Read/GET) Query UserPlaces to display places user has posted
   * (Update/PUT) Update profile image
   * (Update/PUT) Update background image
   * (Read/GET) Query SpotsToPlaces to display spots within the place that the user has posted
* User Map Screen
   * (Read/GET) Query all spots the user has posted
### Endpoints
For places search...
* types = (regions)
   * save place ID
 
For spots search...
* types = address
   * save place ID
   
To get details (lat/lng etc) about a place or spot
https://maps.googleapis.com/maps/api/place/details/json?placeid=PLACE_ID_HERE&key=API_KEY_HERE


