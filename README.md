#LCounting, accountingApp
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

3. setup the environment variables.
	Session Secret is requried for multiple users. Create your own random string, we use 64 characters in the live app.
    ```
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
