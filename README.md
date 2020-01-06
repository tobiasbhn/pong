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