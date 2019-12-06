sudo apt-get update && sudo apt-get install yarn
yarn add bootstrap@4.3.1 jquery popper.js
bundle install
rails db:create db:migrate db:seed assets:precompile
