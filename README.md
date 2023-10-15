# Calcometer

Calcometer helps healthcare workers keep track of distances and time they spend traveling by car between patients. Have a look at the [walkthrough video](https://www.youtube.com/watch?v=P50Yu_BbbCo).

The application has the following core models:

- `User` is the healthcare worker.
- `Patient` is the person that the user visit for appointments.
- `Appointment` is the event made by a user to a patient.
- `Trip` the model containing distance and duration data for a given user in a given day.
- `Address` is a geocoded address with [Nominatim](https://nominatim.org/)

The application calculates the travel distance and duration between patients using the `Directions API` by [OpenRoute Service](https://openrouteservice.org/dev/#/api-docs/v2/directions/%7Bprofile%7D/json/post). The API returns a route between two or more locations for a selected profile and its settings as JSON. From the `summary' of the parsed result, the distance and duration are extracted and displayed to the user.

This app is a proof of concept to:
- solve a real life need with a simple and elegant solution
- build a responsive full-stack app with Ruby on Rails and StimulusJS
- share a high quality app with the open source community

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

4_ Encrypt database
```
bin/rails db:encryption:init
```
4a_ You will see something like this:
```
active_record_encryption:
  primary_key: EGY8WhulUOXixybod7ZWwMIL68R9o5kC
  deterministic_key: aPA5XyALhf75NNnMzaspW7akTfZp0lPY
  key_derivation_salt: xEY0dt6TZcAMg52K7O84wYzkjvbA62Hz
```

5_ Copy the newly created keys and save them in your target environment. The following command will allow you to edit your credentials through VS Code:

```
EDITOR="code --wait" rails credentials:edit
```

5_ Open `app/db/seeds.rb` in your code editor and set how many users, patients and appointments you want to set as per initial database.

6_ Set up the database (creation + migration):
```
rails db:setup
```
7_ Launch a development server
```
bin/dev
```
7a_ If you cloned this repo to your machine, you can create a new (public) repo in your github account (requires `gh` installed)
```
gh repo create --public --source=.
```

TIP: if you don't want users to sign up, you need to:
1. remove sign up buttons from navbar and homepage
2. remove (devise) ':registerable' argument from User model.
3. remove registration routes
Keep the sessions as users they still need to sign in.
