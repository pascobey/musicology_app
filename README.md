# musicology_app
### a.k.a. [graphurmusic.com](https://www.graphurmusic.com)

##### *If you are unable to use this app (because you do not have a Spotify account) check out the [demo video](https://youtu.be/YlqB5HX-Xm8)!* 

This app is a Ruby on Rails project, with the goal of making useful inferences on your music library using Graph Theory.  It currently interacts with Spotify's robust API, and will be expanded to include other interactive streaming services.

Spotify is ahead of the competition with what it makes possible for developers through its API, and via OAuth2.0, your data is safely shared with limited permissions to developers like me.

The app is currently being refactored from a PostgreSQL relational database to a NoSQL (still using PostgreSQL) hybrid graph database.

**Site must be on live server and granted Client ID from Spotify**

*Ruby version 2.6.3*
*Rails version 6.0.0*

*Communications with Spotify API facilitated by [HTTParty](https://github.com/jnunemaker/httparty)*
