<div id="top"></div>

[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://stand-with-ukraine.pp.ua/)

![Status][status-shield]
[![License][license-shield]][license-url]

<div align="center">
<h2 align="center">Syncbl</h2>
  <p align="center">
    Package manager and installer for Microsoft Windows
  </p>
</div>

<!-- ABOUT THE PROJECT -->
# Syncbl Server

There are thousands of installers (no, really, look what the [TUF project](https://theupdateframework.io/) says). But this one is special. Designed to calculate package dependencies, push updates, and process everything in between.

My own applications which uses this API are still proprietary, though, because I have to make money on something, but some of them will also be published in the future. For now I just hope this project will be useful for someone, and I also hope that for someone my best practices there can become useful and motivating.

First of all, it is designed to install add-ons for any games very fast and cool. Its idea was born when my wife once again demanded map for good old Heroes Of Might & Magic III game she loves and I decided to find a way to quickly deliver them to her.

But that's not all! Syncbl is not only allows to install, update and share software really easy, but also helps to remove it without leaving any parts behind. We are working hard to implement this principles in a client applications, which will be introduced soon with new awesome features.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- PROJECT FEATURES -->
## Project features

### Highlights

- [ ] Best way to share with someone a mod for a game you both playing and keep it synced!
- [ ] Manage all your computers from one control panel: install, test and update software on them!
- [ ] One-click restoration after Windows reinstallation!
- [ ] ... TO BE CONTINUED

### Server

- [ ] Software parts can be splitted to packages with very fast calculated dependencies.
    - [ ] Built-in S3 storage support allows packages to update or revert.
    - [ ] Install from anywhere on the Internet using external packages with URLs.
    - [ ] Monitor updates of other software and inform your customers.
- [ ] Full statistic of software installations.
- [ ] Add GDPR related notifications without changing your source code.
- [ ] Manage your software settings, read remote logs, see remote errors.
- [ ] Use the power of included existing opensource repositiories, like WinGet.
- [ ] ... TO BE CONTINUED

In project's Jira its like 100+ tickets right now, but I will move them to issues and features when we will be ready.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- PREREQUISITES -->
## Prerequisites

You will need:
* NodeJS
* Ruby 3.1.0+
* Redis
* Memcached
* PostgreSQL
* (optional) Nginx for some RACK magic

Check out project Wiki for the detailed steps.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- INSTALLATION -->
## Installation

So far just do these steps:
* Copy and edit all `config/*.sample.yml`
* Create corresponding users in your PostgreSQL database
* Set up your S3 environment (or just change destination to `disk` in `config/storage.yml`)
* Run `yarn` to install all Node.JS dependencies.
* Run `rake db:create db:migrate` to prepare database. Additionally run `rake db:seed` to prepare development environment.
* Run `rake assets:precompile` to build all the assets.
* Run `rails s` to check if everything ok.

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

## My gratitude

I really need to thank all of the family, friends and collegues, who encouraged me during my work on that project. And my awesome team, which are, so far:

- Dmitry Ivanov (frontend magician)
- Maksim Sysoev (master of applications)

And of course [Provectus Inc.](https://provectus.com/), because they inspired me!

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[license-shield]: https://img.shields.io/static/v1?label=license&message=gnu%20gplv3&color=blue&style=for-the-badge
[license-url]: https://gitlab.com/syncbl/server/blob/master/LICENSE
[status-shield]: https://img.shields.io/static/v1?label=status&message=early%20development&color=red&style=for-the-badge
