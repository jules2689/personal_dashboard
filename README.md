Personal Dashboard
---
A simple way to track stats about yourself

![Music Dashboard](https://cloud.githubusercontent.com/assets/3074765/13199776/b8215d12-d7fc-11e5-9ec1-a45d7379259c.png)
![Personal Dashboard](https://cloud.githubusercontent.com/assets/3074765/13207152/157d2342-d8d9-11e5-9d75-64c558adb08b.png)

#### LastFM/Spotify
Spotify is supported through scrobbling to LastFM.
Looks at top tracks, artists, time listened in a week, and top tags from last fm

#### GoodReads
Currently grabs your recently read books

#### Social Media
Current supported tracking the number of Twitter followers over time.

#### Meditation
Scrapes Headspace for your profile and pulls in the information

Setup
---
1. Clone the Repo
2. Run 'bundle install'
3. Run `cp .env.example .env`
4. Fill out `.env`
5. Run `bundle exec rake db:create db:migrate`
6. Run `dashing start`