Personal Dashboard
---
A simple way to track stats about yourself

#### LastFM/Spotify
Spotify is supported through scrobbling to LastFM.
Looks at top tracks, artists, time listened in a week, and top tags from last fm

#### GoodReads
Currently grabs your recently read books

#### Social Media
Current supported tracking the number of twitter followers over time.

Setup
---
1. Clone the Repo
2. Run 'bundle install'
3. Run `cp .env.example .env`
4. Fill out `.env`
5. Run `bundle exec rake db:create db:migrate`
6. Run `dashing start`