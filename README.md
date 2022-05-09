## Dependencies Required

#### Ruby on Rails

This application requires :

* Ruby - 2.3.1
* Rails - 4.2.4

To set up Rails on your system, go through the following steps -

  * Install RVM from [RVM Installation Guide](https://rvm.io/rvm/install) and then run the following commands to download the necessary ruby versions -
     * rvm install 2.3.1
     * rvm use 2.3.1 --default


#### Database

This application uses Postgresql Database. To install Postgres database on your system, go through the steps given in the following link -

[Postgres installation steps](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-14-04)

## Installation steps

1. Clone the repo from Source code manager

    use command - *git clone https://bitbucket.org/scriptyx/clinsyte*

2. Install postgresql database if it is not yet Installed on your system.

3. Navigate to the root directory of the project.

4. Get the application.yml configuration file by mailing to [nitesh@scriptyx.com](mailto:nitesh@scriptyx.com). Place the _application.yml_ file under _config_ folder. The file path must be _config/application.yml_.

5. Run the following command to generate database.yml

    *cp config/database.yml.example config/database.yml*

6. Update your database configuration at config/database.yml. Required configurations are:

    Username, Password, Name of the database and Host

7. Install the project dependencies by running:

    *bundle install*

8. Create the database by running:

    *rake db:create*

9. Update your database schema with current migrations by:

    *rake db:migrate*

10. Seed your database with sample data

    *rake db:seed*

11. Install redis on your system if you don't have.

    [Redis Installation Guidelines](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-redis)

12. Start the sidekiq(Background tasks processor) with the following command

    *bundle exec sidekiq -C config/sidekiq.yml*

13. Start the Private Pub rack application for realtime notifications

    *rackup private_pub.ru -s puma -E production*

14. Start your rails server by executing:

    *rails server*

15. Visit localhost:3000 to see the website!
