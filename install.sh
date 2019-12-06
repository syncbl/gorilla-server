# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash
# nvm install 12.13.1

sudo apt-get update && sudo apt-get install yarn
yarn install --check-files
yarn add bootstrap jquery popper.js
bundle install
rails db:create db:migrate db:seed assets:precompile
