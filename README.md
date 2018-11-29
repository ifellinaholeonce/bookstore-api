# README

## Setup

### Prerequisites

```
- Ruby 2.5.3
- Rails 5.2 and up
- Ember 3.5 (frontend)(https://github.com/ifellinaholeonce/bookstore-client)
- Master.key
- Ngrok
```

### Getting Started
A. Master Key
Add the master.key file to config folder

B. Setup DB
```
bin/rails db:create
bin/rails db:migrate
```

C. Bundle
```
bundle
```

D. Run Server
```
bin/rails s -b 0.0.0.0
```

### Github Integration

A. Fire up Ngrok
```
./ngrok http 3000
```

B. Obtain Ngrok Tunnel Address
```
Browse to Ngrok's provided web interface, ie. http://127.0.0.1:4040
Copy the http address to clipboard
```

C. Set ENV variable in terminal
**_Note: This url must contain the http:// prefix_**
```
export WEBHOOK_URL=_ngrok's http address_
```

D. Setup Github Webhook
```
bin/rails github_api:create_webhook
```
**Result: "Issues webhook created for bookstore-api pointed to _WEBHOOK_URL_/github"**

### Seed DB
**Note: Ensure Rails server is running with bin/rails s -b 0.0.0.0 first**

```
bin/rails github_api:create_issues
```

On your server console you will see a number of post request come in from the github webhook. This will seed the database with authors and books.

## Github Integration
**Note: Rails server must be running and Ngrok must be open using the setup URL**

Navigate to the repo: https://github.com/ifellinaholeonce/bookstore-api

### Open Issue
This will send a post request using the webook. The server will create a new author with a name matching the Issue title and a biography matching the Issue description. A book with a random title will also be created, belonging to the new author.

### Edit Issue
This will send a post request using the webhook. The server will update the author's biography to match the new description.

### Delete Issue
This will send a post request using the webhook. The server will delete the author and all book's belonging to the author.
**Note: Delete Issue is in Beta on Github. The delete button can be found on the bottom right under notifications**
![alt text][delete]

[delete]: https://github.com/ifellinaholeonce/bookstore-api/blob/master/docs/delete.png "Logo Title Text 2"