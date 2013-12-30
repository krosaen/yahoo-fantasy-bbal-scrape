Yahoo fantasy basketball scraper
=========================

A ruby script to scrape stats from my fantasy basketball league and summarize weekly
wins / losses in each stat category vs other teams.

Adjust config.rb with your league id and cookie and run

```
mkdir html
bundle install
bundle exec ruby doit.rb
```

Probably won't work with your league until you make some tweaks (e.g this script assumes 10 teams, probably a few
other assumptions baked in), but may be useful for similar stats digging.

Sample output:

```
week,fg,w,l,close,ft,w,l,close,tpm,w,l,close,pts,w,l,close,reb,w,l,close,ast,w,l,close,st,w,l,close,blk,w,l,close,to,w,l,close
1, 0.476, 7, 2, 5, 0.793, 7, 2, 9, 35, 9, 0, 2, 407, 6, 3, 1, 114, 3, 6, 3, 71, 2, 7, 4, 30, 5, 4, 4, 15, 3, 6, 4, 62, 6, 3, 2
2, 0.437, 1, 8, 7, 0.822, 7, 2, 8, 43, 8, 1, 2, 536, 8, 1, 2, 155, 3, 6, 5, 105, 5, 4, 2, 36, 6, 3, 3, 23, 5, 4, 3, 66, 5, 4, 2
3, 0.435, 0, 9, 7, 0.805, 5, 4, 8, 36, 6, 3, 3, 453, 6, 3, 0, 177, 8, 1, 4, 66, 1, 8, 0, 40, 9, 0, 1, 18, 4, 5, 5, 56, 3, 6, 2
4, 0.491, 9, 0, 7, 0.796, 8, 1, 7, 25, 3, 6, 6, 381, 4, 5, 2, 145, 4, 5, 2, 67, 2, 7, 1, 21, 2, 7, 1, 21, 7, 2, 4, 47, 7, 2, 0
5, 0.463, 3, 6, 9, 0.763, 4, 5, 9, 30, 5, 4, 2, 432, 6, 3, 0, 165, 6, 3, 3, 87, 2, 7, 2, 28, 5, 4, 5, 9, 1, 8, 1, 65, 2, 7, 1
6, 0.451, 2, 7, 9, 0.762, 2, 7, 6, 24, 2, 7, 6, 421, 6, 3, 2, 173, 8, 1, 4, 86, 5, 4, 1, 26, 5, 4, 4, 21, 9, 0, 2, 48, 6, 3, 0
7, 0.478, 4, 5, 7, 0.793, 2, 7, 9, 30, 4, 5, 5, 450, 5, 4, 0, 132, 2, 7, 2, 100, 4, 5, 2, 30, 5, 4, 5, 21, 7, 2, 3, 59, 4, 5, 3
8, 0.505, 8, 1, 5, 0.747, 2, 7, 7, 29, 6, 3, 8, 404, 5, 4, 0, 148, 3, 6, 4, 87, 3, 6, 4, 21, 0, 9, 4, 19, 7, 2, 4, 59, 2, 7, 2
9, 0.506, 7, 2, 8, 0.807, 5, 4, 9, 29, 4, 5, 6, 455, 7, 2, 3, 151, 4, 5, 4, 88, 6, 3, 4, 22, 3, 6, 4, 20, 8, 1, 2, 56, 2, 7, 1
```

E.g in week 9, with a field goal percentage of .506 I'd win that category against 7 teams, lose vs 2, and be close
against 8 teams. Looking across these stats helps me determine which categories I'm most competitive or close
in and which ones I may as well punt on.