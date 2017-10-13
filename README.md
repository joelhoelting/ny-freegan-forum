## Freegan Forum

[www.freeganforum.com](www.freeganforum.com)

### Introduction

A CRUD (Create, Read, Update and Delete) web app with a back-end built in Sinatra using Test-Driven Development (TDD). Front-end styled with Javascript, Bootstrap and Sass using a modified version of the [Grayscale](https://startbootstrap.com/template-overviews/grayscale/) bootstrap theme. The NY Freegan Forum allows the freegan community in New York to collect and contribute information about freeganistic activities in the five boroughs. Visitors do not need to be logged in to view any of the reports. For user authentication, username and password validators were created with a combination of Ruby and RegEx. Logged in users can create new reports and can edit and delete their reports.

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

In order for this app to function, you must seed it with the included 5 boroughs:

```
$ rake db:seed
```

Host on local server:

```
$ shotgun
```


### Contributing

Contributions to the project are welcome. Please send pull-requests to the upstream repository. If you make some useful contributions I will grant you direct access to the main repository. My bigger goal is to create more cities and to branch out from NYC. If you'd like to build some more models and tables for the database, I would be interested to see what you can develop.

## License

GPL License v2 | Copyleft (c) 2016 Joel Hoelting

[https://joelhoelting.com](https://www.joelhoelting.com)
