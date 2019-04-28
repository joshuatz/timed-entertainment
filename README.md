# timed_entertainment
## App Idea
An app based around a silly idea: Finding and auto-playing a YouTube video that is the same length (or as close to) as a countdown timer that you control. So if you want to watch a video while you brush your teeth for 2 minutes, you can set the timer on the homescreen of the app for 2 minutes and simply hit start!

The app uses the YouTube api to pull videos that are close to the duration you requested, then sorts the results and filters against videos you have already seen (WIP) so that you get a new video each time, even if you keep requesting the same duration. You can also pick the source of the videos (e.g. find videos that match keyword "Javascript Tips" or pull vidoes from "currently trending").
## Screenshots
## Progress / future
This is a prototype app (my first Flutter app, and my first mobile app), which I am building for fun and to get a sense of how Flutter might or might not be a good fit for any future cross-platform app dev needs I might have. I'm not sure how far I'll take this idea...
# Backlog
 - Keep track of video progress
     - On video pause, store progress
     - When starting timer, IF (in paused videos, duration left ~= timer) THEN resume video
     - Block replays from happening (depending on global settings and config settings)
 - Overlay countdown timer on top of currently playing video
 - Pause timer on video pause
# Icebox
 - Homescreen widgets (could be a preset combo of timelength + config)
 - Sources other than YouTube (e.g. local files, internet radio, start and stop installed app, etc.)