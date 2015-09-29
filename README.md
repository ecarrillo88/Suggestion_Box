# AlertaCiclista

[Demo](https://demo-alertaciclista.herokuapp.com/)

### Requisitos
 - Ruby 2.2.2
 - Git
 - Bundler

```bash
$ git clone git@github.com:devscola/alerta_ciclista.git
$ cd alerta_ciclista
$ bundle install --without production
$ cp config/examples/* config
$ bundle exec rake db:setup
$ bundle exec rails s
```

## Instalación en Heroku
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

### Tareas post-despliegue:
  1. Cambiar el valor de la variable de entorno APP_HOST por la url de la nueva aplicación creada.
  2. Programar diariamente los trabajos definidos en [lib/tasks/scheduler.rake](https://github.com/desarrollolocal/Suggestion_Box/blob/master/lib/tasks/scheduler.rake) en el add-on Scheduler.


### CLI
  - [heroku toolbelt](https://toolbelt.heroku.com/)
  - [Deploy Rails apps in heroku](https://devcenter.heroku.com/articles/getting-started-with-rails4)
  - Addons: [app.json](https://github.com/desarrollolocal/Suggestion_Box/blob/master/app.json)

[![Build Status](https://travis-ci.org/devscola/alerta_ciclista.svg?branch=master)](https://travis-ci.org/devscola/alerta_ciclista)
