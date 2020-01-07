# PONG
## Introducion
This Repository will be used building an dynamic Webapplication running on Ruby on Rails. This Application should allow the User to play the traditional PONG Game Online. In addition, there will be special Mode (Party Mode) which lets the User control their Game via their Smartphones.

## Behaviour Examples
* Multiple Pages:
  * If a user visits one of the static Pages Multiple times, noting changes.
  * If a user visit the dynamic Game Page `/game/:id` it will decide which Action will be performed (Host, Play, Queue, Invite)
  * Only One User can Host a Game
  * All other User are either playing or in Queue, if theire alredy authenticated
  * If their not authenticated, the dynamic Game Page `/game/:id` will function as Invite Link
  * One User ~~can/~~cannot open one Game in multiple Tabs or Browser Windows
  * If the User opens the same Game in multiple Tabs/Windows, it will output a brief massage. (e.g. 'If you want to Play against each other on the same Machine, please use Spitscreen Mode.')

* Reload / Revisit
  * If I reload the Page as a Host, I want to continue the same Game, but restart the Round
  * If I reload the Page as a Player, I want to stay in the same Game, but will be at the End of the Queue

## Request Examples for /:game_id

| URL      | Cookie Set | Cookie Consumer Exists | Cookie Consumer Type | Cookie Consumer Game | Game Exists | Game Mode | Result           |
| :------: | :--------: | :--------------------: | :------------------: | :------------------: | :---------: | :-------: | :--------------: |
| `/12345` | true       | true                   | "Game"               | `12345`              | true        | /         | `#host_game`     |
| `/12345` | true       | true                   | "User"               | `12345`              | true        | /         | `#play_game`     |
| `/12345` | false      | /                      | /                    | /                    | true/false  | /         | `#invite`        |
| `/12345` | true       | false                  | /                    | /                    | true/false  | /         | `#invite`        |
| `/12345` | true       | true                   | "Game"               | `54321`              | true/false  | /         | `#invite`        |
| ... | ...       | ...                   | ...               | ...              | ...  | ...         | ...       |



Auth?
Im richtigen Game?


Show:
| Requested Game | Already Auth? | Auth in Game | Result |
| :-: | :-: | :-: | :-: |
| `11111` | true | `11111` | successful |
| `11111` | true | `22222` | failure |
| `11111` | false | / | failure |

Create Game:
| Cookie present? | Action |
| :-: | :-: |
| true | 
| false | Create Game Normally & Set Cookie |


Game Destroy: All Players are Destroyed, Game Tupel gets destroyed, redirected to Index if online, can not access this specific game again
Game Deactivate: 
Player Destroy: Player Tupel gets destroyed, redirected to Index if online



## Mode Overview:
* Party: 1 Gameview without Controls (Host) + n Controls(User)
  * form: only modeswitch - pupblic gamekey generated
* Multiplayer: 2 Gameviews + Controls (1 Host + 1 User) + n Mirror without Controls
  * form: modeswitch + private Checkbox, which can be used to lock game with private password
* Splitscreen: 1 Gameview + 2 Controls + n Mirror without Controls
  * form: 