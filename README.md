# Calcometer

The purpose of the app is to help healthcare workers keep track of the distance
and time they spend traveling by car between patients.

The application has the following models:

- `User`: Represents the healthcare workers.
- `Patient`: Represents the patients that the healthcare workers visit for appointments.
- `Client`: Represents the organisations who have one or more patients.
- `Appointment`: Represents the visits made by a user to a patient.

The application calculates the distance and time spent traveling between patients using the [Geocoder](https://github.com/alexreisner/geocoder).

In the backend, different views and controllers to handle these calculations:

- `calculate_driving_distance`: Calculates the distance between two patient addresses using [Nominatim](https://wiki.openstreetmap.org/wiki/Nominatim).
- `calculate_driving_time`: Calculates the time spent traveling between two patient addresses, based on the distance and an `average_speed` of 50 km/h.

On the appointments view, the user sees the patient information, start time and end time, updated daily. The distance and time calculations are updated in real-time as the user updates their appointments.

Overall, the application should meet the requirements of helping healthcare workers keep track of their travel distances and times.

# Initial setup

- Clone the repo to your local machine
- Create an .env file and include your MAPBOX_ACCESS_TOKEN for rendering static maps in patients show view
- run
```
bundle && yarn
```
- [OPTIONAL] if you feel risky, run
```
bundle update && yarn upgrade
```
- in app/db/seeds.rb, you can set how many users, patients, organisations and appointments you want to set; then run
```
rails db:setup
```
- run
```
bin/dev
```
TIP:
- to create a new public repo in your github account, run
```
gh repo create --public --source=.
```
