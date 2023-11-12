# README

This is a demo of Forecast project.

Requirement:
User input an address, show forecast. including temparature now, min and max etc.


1. User type in address
2. Autocomplete provide accurate addresses for user to pick (AWS Location Service provide suggestions)
3. User pick one address (a unique one)
4. Find zip code of address, if no zip code by default, then query location by latitudes and longtitude again to fetch zip code.
5. Call Forecast API to get data by zip code, cache it (Tomorrow API)
6. Presentation: Display forecast data and Map (chart.js)


# Todo
Remember user's address selection history, easier to pick next time

There are other data available