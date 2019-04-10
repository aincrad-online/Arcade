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

[x] - User can navigate a main menu screen
[ ] - User can start a new game from the menu screen
[x] - User can access a settings page from menu
[ ] - User highscore is saved locally

**Optional Nice-to-have Stories**

[ ] - Users can log in and save highscores online
[ ] - User can acces a leaderboard on the menu page and see top 100 scores

### 2. Screen Archetypes

* #### Welcome Screen
   - [ ] Start new game option
   - [x] Enter settings screen
   - [ ] (Optional) Enter leaderboard screen
* #### Game screen
   - [ ] User can play the space invaders game
   - [ ] When the user dies they have the option to play again or restart
* #### Settings screen
   - [ ] User can control music (turn down/off)
   - [ ] User can reset local highscore
* #### (Optional) Leaderboard Screen
   - [ ] User can view top 100 scores saved on server from other users

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
        score["author"] = AuthorLabel.text


        score.saveInBackground { (success, error) in
            if success{
                print("score saved")
            }
            else{
                print("error posting score: \(error)")
            }
        }
         ```
      - (Read/GET) Query submitted highscores
         ```swift
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell             {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell") as! ScoreCell
            let score = scores[indexpath.row]
            

            cell.scoreLabel.text = score["text"] as? String        
            cell.nameLabel.text = score["author"]
            
            return cell
        }
         ```

## Video Walkthrough of Progress from Sprint 1
<img src='https://i.imgur.com/miDceT8.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

