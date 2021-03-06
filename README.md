## Test tasks

Text of test tasks https://github.com/kruglay/TestTasksValucon/blob/master/public/test_tasks.pdf

After clone application put in console
```
  bundle install
  bundle exec rake db:migrate
```
### №1 Feedback module

RSpec+capybara test for feedback form.

#### Usage

Visit main paige, click link `Feed back` than put email format: `example@mail.com`
write some text into text field and click 'Send' button. You will be redirected to
`contacts/new`

### №2 Trello wrapper

Use Trello API to fit following flow of usage

#### Configuration

Add `HOME/.trellorc` file with format
```
  developer_public_key: <key>
  member_token: <token>
```
to authenticate to trello API. <key> and <token> you can get here https://trello.com/app-key
All files are located in `/lib/trello_api`

#### Usage

Put in Rails console
```
  require_relative 'lib/trello_api/trello_board'
  puts TrelloBoard.list_boards # check your boards, and find nessesary board ID
  board = TrelloBoard.new("board_id") # your trello board id
  puts board.lists # check board lists and find nessesary list ID
  board.create_card!(title: "some_title", description: "some_description", list_id: "board_list_id")
```
### №3 Rake Task and Sidekiq Worker

Rake task that query Rubygems API for all the versions of Rails gem.
Check versions in local DB and download it if not found.

#### Configuration

Copy config/app.expample.yml to config/app.yml and put your settings.
Before use sidekiq install [redis](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-redis-on-ubuntu-16-04)
```
  cp config/app.example.yml config/app.yml
```
Change local path to save gems
```
  path:'/home/some_user/gems/' # local path for saving gems
```
#### Usage

Put in console
```
  rake 'check_gems[gem_name]'
  bundle exec sidekiq
```
to check gem with name 'gem_name'

## #№4 Template

A responsive design.

put `/template` in your adress bar to see the page

## №5 Storage

Allow to add pictures via S3 Amazon services.
Use dragonfly gem to add picrures.
Shows all uploaded pictures in 100x100px format.

#### Configuration

Add S3 variables to environments in secrets.yml for example
```
 development:
     ENV:
         S3_BUCKET_NAME: 'your bucket name'
         S3_ACCESS_KEY:  'your access_key_id'
         S3_SECRET_KEY:  'your secret_access_key'
```
Use dragonfly.example.rb as the example to configure dragonfly.rb.
Look https://github.com/markevans/dragonfly-s3_data_store for more information about configure dragonfly.rb.

======
