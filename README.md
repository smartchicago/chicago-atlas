## Chicago Health Atlas

The Chicago Health Atlas is a place where you can view citywide information about health trends and take action near you to improve your own health.

## Installation

This is the Back-end and Administrator Part of the Chicago Health Atlas. We advice deployment on Heroku as there are many service requirements and to keep maintenance costs low and to make life easy on yourself while developing for another city.

At the moment, we have some services requirements. There is a need for Sidekiq, Redis and Postgres. You can find all of the Environmental Variables in the Environmental Example File.

1) Just clone the app to your local machine 'git clone'

2) Go to Heroku and create a new application

3) Due to the heavy data that you might upload, I would recommend a worker dyno and a web dyno, but it actually works in free and hobby environment (do not ask us about heavy load on that one)

4) Redis is needed and you can use the free version of Heroku, so that no additional costs are required. There is no need for heavy lifting, we are only going to use it when we upload files, and most likely we are going to do that once.

###  deployment

Then it is time to deploy our database. So here we go. After you have run 'bundle install' or better yet 'heroku run rake bundle install', it is time to deploy our database.

1) run 'rake db:migrate', yes that is 'rake' and not 'rails'.

2) run 'rake db:seed', there is one generic admin user in there.

3) run 'rake db:import:all', yes this is a custom one and this might take up to 30 minutes, so do get some coffee in the meanwhile

You are totally done!

## Monitoring of the App

We have placed AppSignal Gem inside of the Gemfile. If that is not needed, then feel free to remove it. AppSignal (see www.appsignal.com) is a system that will monitor the app from all perspectives and will help you with guidance on any errors and or heavy load warnings that you might encounter. The implementation is easy.

1. 'bundle Install' (if you have not done so)

2. Go to appsignal and make an account

3. Follow the steps in Appsignal

We like to know if you encounter any issues and certainly are open for improvements.

## File Template for Topic Data

The Chicago Health Atlas consists of 3 parts one of which is Topic Data. The Chicago Health Atlas reports on a range of topics, ranging from Adult Binge Drinking, Homicides, Smoking and other topics that are related to the core mission of the Healthy Chicago 2.0. team, which are to monitor and enhance the livelihood of the wonderful City of Chicago. If you are in need for a template, please have a look in the downloads folder where we placed an example. If you need any help please reach out to John Doe at X.

## API Reference

The Chicago Health Atlas uses external services and what we call static data. Static Data is that data that does not change overtime, you can think of GPS co-ordinates for ZIP and Community Areas.

## Worker Killer!

Okay, so you started off with a small Dyno on Heroku and you had a 15.000 line file and something went wrong. Next thing you know is that the Machine starts to squeek and everything stops! Don't worry! We have your covered! While we do recommend you to make an update on the Dyno, it wouldn't hurt the app as immediately we are resetting your dyno's and no data is lost and you are back to business. It might also be that overtime (think weeks, months) memory usage starts to slightly increase. An auto-reset is easy.

If you do not want to use this in production, then please move the 'gem 'puma_worker_killer' to the 'development test' group on the Gemfile or remove it all together (not recommended by author).

## Our Tests that we have done on this Codebase

We have extensively tested the endpoints and concluded that everything runs well under 1000MS (most of it under 500MS) when run on a single dyno and concurrency of 75 users per minute no evenly divided. Our tool of choice has been loader.io. If you have come this far and are still reading (which hopefully you do as this is important), we have to tell you that our loader file is still in the Public folder. That means that if you do not remove it, we are able to run loader.io with 9999 users over less than a minute on your server..., so I highly recommend you replace that with your own!

Now as mentioned, we also have APPsignal running on here, but we removed our API keys so that is good.

## Contributors

This App is build and maintained by Dom & Tom and its development partner Parrolabs who worked between November 2016 and March 2017 to bring this app to a new version. Any feedback can be sent to: John Doe at X.

If you feel you have an update for us, don't hesitate to make a new Branch and a Pull Request!

## License

The ChicagoHealth Atlas is Fully Open Source. It means, yes you can do whatever you want with it. The Chicago Team appreciates it if you make a reference to them, but yeah you could turn this map into a map of Lima, Sydney and pretend you made all of it. Don't hesitate to reach out to John Doe at X to tell us about your efforts and we are ready to help you!
