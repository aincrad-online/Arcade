Unit 8: Group Milestone
===

# ARCADIA

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description


### App Evaluation

- **Category:** Game
- **Mobile:** The app would primarily be developed for use on mobile platforms as well as the iPad. It could be developed for use on laptops as well.
- **Story:** User plays game where they control a ship and shoot rocks/enemies while attempting to get a high score.
- **Market:** Availible for all ages. The users are not connected, so there will be no communication. 
- **Habit:** This app can be used when users are bored and need something to help them pass the time by.
- **Scope:** The user would first start with few, slow rocks and no enemies. As the game progresses, the rocks will increase in number and speed. The enemies will do so as well.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can navigate a main menu screen
* User can start a new game from the menu screen
* user can access a settings page from menu
* User highscore is saved locally

**Optional Nice-to-have Stories**

* Users can log in and save highscores online
* User can acces a leaderboard on the menu page and see top 100 scores

### 2. Screen Archetypes

* #### Welcome Screen
   * Start new game option
   * Enter settings screen
   * (Optional) Enter leaderboard screen
* #### Game screen
   * User can play the space invaders game
   * When the user dies they have the option to play again or restart
* #### Settings screen
   * User can control music (turn down/off)
   * User can reset local highscore
* #### (Optional) Leaderboard Screen
   * User can view top 100 scores saved on server from other users

### 3. Navigation


**Flow Navigation** (Screen to Screen)

* Main Menu
   * Settings -> Toggle Settings
   * Start Game -> Game starts playing

## Wireframes
![Alt text](wireframe.jpg?raw=true "project_wireframe")

## Schema 
### Models

#### Scores

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | author        | Pointer to User| player's username |
   | score         | Number     | player's high score |
   | createdAt     | DateTime | date when score is achieved (default field) |
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
#### List of network requests by screen
   - Home Feed Screen
      - (create/POST) Submit a highscore
         ```swift
        let score = PFObject(className: "Scores")
        score["score"] = int(currentScoreLabel.text)
        comment["createdAt"] = currentDate
        comment["author"] = AuthorLabel.text

        selectedPost.add(score, forKey: "scores")

        selectedPost.saveInBackground { (success, error) in
            if success{
                print("comment saved")
            }
            else{
                print("error posting comment: \(error)")
            }
        }
         ```
      - (Read/GET) Query submitted highcores
         ```swift
         let query = PFQuery(className:"Scores")
         query.whereKey("author", equalTo: currentUser)
         query.order(byDescending: "createdAt")
         query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if let posts = posts {
               print("Successfully retrieved \(posts.count) posts.")
           // TODO: Do something with posts...
            }
         }
         ```


