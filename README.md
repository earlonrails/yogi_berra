[![Build Status](https://travis-ci.org/earlonrails/yogi_berra.png?branch=master)](https://travis-ci.org/earlonrails/yogi_berra)

Yogi Berra
==========

 "If the world were perfect, it wouldn't be." - Yogi Berra

Yogi Berra was the best catcher of all time.
This gem will catch all of your rails error in production or development and store them in mongodb if
it can. It uses the mongodb_ruby_driver in a non-blocking way.

    Mongo::MongoClient.new(host, port, :w => 0)

The `:w => 0` option here makes requests to the mongodb server not wait for a response.
This will begin to fill a buffer when there is no connection. When the connection returns
the buffer will be entered into the database. There can be data loss if the buffer overflows.
There are some messages in the logs which will tell you if the connection is down.
This makes the catcher work when it does and not crash or slow when it doesn't.

Installation
------------

add yogi_berra to your Gemfile:

    gem 'yogi_berra'

Create a yogi.yml file in rails root config/ folder. Here is a sample:

    defaults: &defaults
      username: yogi
      password: berra
      project: yogi_project

    development:
      <<: *defaults
      database: yogi_berra
      host: localhost
      port: 27017

Without Rails
-------------

Set `YOGI_ENV` variable to tell yogi which environment you would like to use.
For instance given the previous yaml file, one could use `YOGI_ENV=development`.

Use `YogiBerra::Catcher.load_db_settings("location_to_some_yaml_file.yml")` to load your database settings.

Finally store a rescued exception:

    YogiBerra::Catcher.connect
    begin
      raise Exception
    rescue => raised
      YogiBerra.exceptionize(raised)
    end

View
----
To view the exceptions you check them in the database or install this rails app.
https://github.com/earlonrails/yogi_berra_scoreboard.git

Thanks
------

To :
  - Thoughtbot Airbrake:
    https://github.com/airbrake/airbrake/tree/master/lib/airbrake
    This gem is awesome and was the base for most of the code here.

  - Exception Engine:
    https://github.com/Consoci8/exception_engine
    Which is an app which was the inital fork to start this code base.
    Just took out the need for mongoid, and a rails app. Made it into a gem
    that will later have a rails app to view the exceptions. Exception engine also
    credits Thoughtbot for the Hoptoad::Notice part of the code. Hoptoad is now airbrake.

