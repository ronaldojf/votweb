# votweb

This project is a [Rails](http://rubyonrails.org/) application used to SOMETHING.

## Dependencies

To run this project you need to have:

* Ruby 2.3.1 - You can use [RVM](http://rvm.io)
* [PostgreSQL](http://www.postgresql.org/)
  * OSX - [Postgress.app](http://postgresapp.com/)
  * Linux - `$ sudo apt-get install postgresql`
  * Windows - [PostgreSQL for Windows](http://www.postgresql.org/download/windows/)

If you plan to **integrate** this project to Heroku, you'll need:

* [Heroku Toolbelt](https://toolbelt.heroku.com/)

## Setup the project

1. Install the dependencies above
2. `$ git clone <REPOSITORY_URL> votweb` - Clone the project
3. `$ cd votweb` - Go into the project folder
4. `$ bin/setup` - Run the setup script
5. `$ bin/rspec` - Run the specs to see if everything is working fine

If everything goes OK, you can now run the project!

You can see an example here: http://showterm.io/6a0054fb8b6b53a56ef2c#slow

## Running the project

1. `$ bundle exec foreman start` - Opens the server
2. Open [http://localhost:3000](http://localhost:3000)

#### Running specs and checking coverage

`$ bundle exec rake spec` to run the specs.

`$ coverage=on bundle exec rake spec` to generate the coverage report then open the file `coverage/index.html` on your browser.

## Deploying the project to Heroku

:warning: This is the **ONLY RECOMMENDED WAY** to integrate this project, please do not push directly to Heroku.

#### Deploying the project to a single/staging app on Heroku

1. You are working on `master` branch
2. `$ bundle exec rake integrate` - Deploy everything to your app
3. Check if the changes are working on Heroku

You can see an example here: http://showterm.io/a4f25718904e532b321ad#slow

#### Deploying the project to production app on Heroku

This is only applicable if you have two apps on Heroku (staging and production).

First, check of your project has the correct configuration from [jumpup-heroku](https://github.com/Helabs/jumpup-heroku#usage).

1. You are working on `master` branch
2. `$ git checkout production` - Checkout to `production` branch (this branch must be called `production`)
3. `$ git merge master` - Merge the changes from `master` branch (don't use rebase here)
4. `$ bundle exec rake integrate:production` - Deploy everything to your production app
5. `$ git push -u origin production` - Send your changes to `origin` remote and set the upstream
6. `$ git checkout master` - Checkout to `master` branch (so you don't commit directly on `production` branch)

:warning: All your daily work must be done on the `master` branch (or in a feature branch), never on `production` branch! The only thing you do on `production` is merging the changes from `master` and deploying to Heroku.

## Generated with PAH

Generated with [PAH](https://github.com/Helabs/pah), an open source project created and maintained by [HE:labs](http://helabs.com.br).
