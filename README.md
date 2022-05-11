<div id="top"></div>

![Status][status-shield]
[![License][license-shield]][license-url]

<br />
<div align="center">
<h2 align="center">Syncbl</h2>
  <p align="center">
    Package manager and installer for Microsoft Windows
  </p>
</div>

<!-- ABOUT THE PROJECT -->
# Syncbl Server

There are thousands of installers (no, really, look at the [TUF project](https://theupdateframework.io/), they say so), but this one is special. Its backend is designed to quickly calculate package dependencies, push updates, and process everything in between. I am trying to add security to it, but so far it is not at the highest level and together we will fix that.

My own applications which uses this API are still proprietary, though, because I have to make money on something, but some of them will also be published in the future.

I hope this project will be useful for someone, and I also hope that for someone my best practices there can become useful and motivating. Let's write the best installer in the world together!

First of all, it is designed to install add-ons for any games very easily and cool. Its idea was born when my wife once again demanded map for good old Heroes 3 she loves and I decided to find a way to quickly deliver them to her. But that's not all!

Syncbl is not only allows easy install, update and share software, but also helps quickly remove it without leaving any parts behind. Of course, this depends on the implementation of the clients, but the backend provides everything for this.

Anyway, to be honest, I just love the good old filling progress bars and just wanted to try my hand at something big.

<p align="right">
(<a href="#top">back to top</a>)</p>

<!-- PREREQUISITES -->
### Prerequisites

You will need:
* NodeJS
* Ruby 3.1.0
* Redis
* Memcached
* PostgreSQL
* (optional) Nginx for some RACK magic

Detailed installation steps:
* In before
  ```sh
  sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev libpq-dev
  ```
* NodeJS for assets
  ```
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm install --lts
  nvm use --lts
  npm install --global yarn # Because gentlemen uses Yarn
  ```
* Rbenv to install Ruby
  ```
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc
  source ~/.bashrc
  git clone https://github.com/rbenv/ruby-build.git
  PREFIX=/usr/local sudo ./ruby-build/install.sh
  rbenv install 3.1.0
  ```
* Final preparations, after you will clone the project
  ```
  bundle install
  yarn install
  rake db:create db:migrate db:seed
  ```

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- INSTALLATION -->
### Installation

Well, I definitely will fill this section, but so far just copy and edit all `config/*.sample.yml`, create corresponding users in your PostgreSQL database, set up your S3 environment (or just change destination to `disk` in `config/storage.yml`) and run `rails s` to check is everything ok.

<!-- ROADMAP -->
## Roadmap

- [ ] Feature 1
- [ ] Feature 2
- [ ] Feature 3
    - [ ] Nested Feature

...Because, I have no idea so far. I mean, in my own Jira its like 100+ tickets right now, but I will move them to issues and features when I will be ready.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement". Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the GNU GPLv3, see `LICENSE` for more information. I plan to go the GitLab way: after leaving the early development stage, the server will be renamed and split into different parts, with the main core free under GNU GPLv3 and enterprise services under commercial license with subscription terms.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

Eldar Avatov - [@e1.avat](https://facebook.com/e1.avat) - eldar@syncbl.com

<p align="right">(<a href="#top">back to top</a>)</p>

## My own gratitude

I really need to thank all of the family, friends and collegues, who encouraged me during my work on that project. And my awesome team, which are, so far:

- Dmitry Ivanov (awesomest frontend magician)
- Maksim Sysoev (master of applications)

And of course [Provectus Inc.](https://provectus.com/), because they inspire me in so many levels! Thank you and I love you, guys!

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[license-shield]: https://img.shields.io/static/v1?label=license&message=gnu%20gplv3&color=blue&style=for-the-badge
[license-url]: https://gitlab.com/syncbl/server/blob/master/LICENSE
[status-shield]: https://img.shields.io/static/v1?label=status&message=early%20development&color=red&style=for-the-badge
