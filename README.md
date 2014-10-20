spicybattle
===========

Statistics and data aggregation site for Adventure Time Battle Party by Cartoon Network. www.spicybattle.com

#Table of Contents

1. Purpose
2. Technologies
3. Design and Architecture

---

##Purpose

Adventure Time Battle Party(ATBP) is a game produced by Cartoon Network(CN) that lacked a transparent system for reviewing and sharing gameplay statistics and personal records.

This application uses Google Chrome Extensions and a web server to request data from a private CN API. The server aggregates data and allows players to view both their own statistics and those of others via the web app.


##Technologies

####Front End

AngularJS, NVD3, UI-Router, JQuery, Bootstrap, Lodash, Local Storage.

####Back End

Express/Node.js, MongoDB, Coffeescript, Jade, Stylus.

##Design and Architecture

####Design Goals

1. Serve statistics to players via a web application.
2. Store data for retrieval in future.
3. Provide global statistical trends and analysis.

####Design Overview

1. Players register their accounts to the web app by installing the Google Chrome Extension, then logging into their CN accounts. The Chrome Extension will inject a script into the page that retrieves the TEGid and AuthID from an object in the global namespace. These IDs are required for an API call to retrieve the profiles and data of the player. The script will POST the IDs to the Node.js server to be stored in a MongoDB collection.

2. On the server-side, a GET request is made to the CN API to retrieve data, and the data is committed to MongoDB. At this point, the data is available to be served on the web app via a REST endpoint. Data is requested using the latest IDs whenever data is older than a certain time period (~10 mins).

3. There are several auxiliary scripts run via Heroku scheduler that compute and store global statistics.

####Architectural Problems and Solutions

* To curb abuse and reduce server load, a rate-limiter is in place that rate-limits by player name. Repeated calls to the same player data will return with existing data immediately, rather than making a GET request for new data. This is because matches are usually 15 minutes long, and 90% of the time, there will be no new data <10 minutes before the latest match.

* Due to limited database space, there is a script(run once a day) that reduces and caps the matches stored per player to 100.

####Possible Improvements to Existing Problems

* Matches are not currently linked together, so if two players played with each other, they wouldn't be able to see it on their respective profiles. A possible solution would be to hash several unique fields together to make a unique match ID, then store all matches in their own collection. This would also reduce redundant data being stored. An issue with this solution is that using Object reference IDs and populating 100+ fields may be slow.