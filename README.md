## Freegan Forum

### Introduction

A CRUD (Create, Read, Update and Delete) web app with a back-end built in Sinatra using Test-Driven Development (TDD). Front-end styled with Javascript, HTML and Sass. The NY Freegan Forum allows the freegan community in New York to collect and contribute information about freeganistic activities in the five boroughs. Visitors to the site can view all reports, or view reports by borough, without logging in. For user authentication, username and password validators were created with a combination of Ruby and RegEx. Logged in users can create new reports and can edit and delete their reports.

### Installation and Usage

Github repository of the project: [https://github.com/joelbitar1986/ny-freegan-forum](https://github.com/joelbitar1986/ny-freegan-forum).

After cloning the repository:

```
$ bundle install
```

Run migrations:

```
$ rake db:migrate
```

Seed database:

```
$ rake db:seed
```

Host on local server:

```
$ shotgun
```


### Contributing

All contributions to the project are welcome. Please send pull-requests to the upstream repository: [https://github.com/joelbitar1986/ny-freegan-forum](https://github.com/joelbitar1986/ny-freegan-forum)

## License

GPL License v2 | Copyleft (c) 2016 [Joel Bitar](http://www.joelbitar.space)
