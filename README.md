# Calcometer

The purpose of the app is to help healthcare workers keep track of the distance and time they spend traveling by car between patients.

The application has the following core models:

- `User` is the healthcare worker.
- `Tenant` is the team to whom patients belong to and the user works for.
- `Patient` is the person that the user visit for appointments.
- `Appointment` is the event made by a user to a patient.
- `Trip` the model containing distance and duration data for a given user in a given day.
- `Address` is a geocoded address with [Nominatim](https://nominatim.org/)

The application calculates the travel distance and duration between patients using the `Directions API` by [OpenRoute Service](https://openrouteservice.org/dev/#/api-docs/v2/directions/%7Bprofile%7D/json/post). The API returns a route between two or more locations for a selected profile and its settings as JSON. From the `summary' of the parsed result, the distance and duration are extracted and displayed to the user.

This app is a proof of concept for building:
- responsive full-stack app with RoR and StimulusJS
- open source high quality
- solve a real life problem with a simple and elegant solution

# Initial setup

1_ Clone or fork the repo

2_ Create an `.env` file and include the following keys:
- OPENROUTE_API_KEY* for performing the distance and duration calculation (this is required for the functioning of the app)
- MAPBOX_ACCESS_TOKEN for rendering static maps in patients show view (through 'mapkick-static')
- GOOGLE_OAUTH_CLIENT_ID for oauth login with Google
- GOOGLE_OAUTH_CLIENT_SECRET for oauth login with Google

3_ Install dependencies (Ruby & Javascript)
```
bundle && yarn
```
3a_ [OPTIONAL] if you want to update dependencies, run
```
bundle update && yarn upgrade
```
4_ Open `app/db/seeds.rb` in your code editor and set how many users, patients, tenants and appointments you want to set as per initial database.

5_ Set up the database (creation + migration):
```
rails db:setup
```
6_ Launch a development server
```
bin/dev
```
6a_ If you cloned this repo to your machine, you can create a new (public) repo in your github account (requires `gh` installed)
```
gh repo create --public --source=.
```
