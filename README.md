#LCounting, accountingApp
[This is Live!](http://accounting-app.herokuapp.com/)
This is an app designed to simplify the way roommates keep track of shared expenses. It can also be used for things like roadtrips, where multiple people are sharing the cost of many items.

LCounting sends an invoice to all group members, giving them a break down of shared expenses, and who owes what.

Any group member is able to post a cost to the group.

Rent, Bills, Food, a solution to get paid back.

# Setup
1. download the project
    ```
    git clone git@github.com:alexvonhafften/accountingApp.git
    cd accountingApp
    ```

2. install dependencies
    ```
    bundle install --without production
    ```

3. setup the environment variables. If you want to be able to send emails, you must also configure EMAIL_USERNAME, and EMAIL_PASSWORD to point to your desired account, currently set up for a gmail acccount. See App.rb send_email function for configuring different mail servers.
	SESSION_SECRET is requried for multiple users. Create your own random string, we use 64 characters in the live app.
    We are using the 'dotenv' gem for handling environment variables. Setting ENV vaiables is done in a .env file in the root directory. You will have to create this yourself, .gitignore will skip this file for security reasons.
    ```
    EMAIL_USERNAME=youraccount
    EMAIL_PASSWORD=yourpassword
    SESSION_SECRET=VHJKXVHSJKXBHJKWBHGXJWKHJ
    ```

4. setup the database
    ```
    rake db:migrate
    ```

5. start the development server
    ```
    shotgun
    ```
6. point your web browser to [http://127.0.0.1:9393/](http://127.0.0.1:9393/) to see the app in action.
