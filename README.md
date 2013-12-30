Yahoo fantasy basketball scraper
=========================

A ruby script to scrape stats from my fantasy basketball league and summarize weekly
wins / losses in each stat category vs other teams.

Adjust the script with your league id and cookie and run

```
mkdir html
bundle install
bundle exec ruby doit.rb
```

Probably won't work with your league until you make some tweaks (e.g this script assumes 10 teams,
hard codes in my team name), but may be useful for similar stats digging.
