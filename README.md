# Buzón Sugerencias

##Características

**Buzón** es una aplicación pensada para que los vecinos de pequeños ayuntamientos
puedan reportar problemas, sugerir ideas, notificar incidencias, etc. que
sean de interés para el resto de vecinos y también para el propio órgano de
gobierno del municipio.


### Reportar una sugerencia
Un vecino rellena el formulario, donde no hace falta registrarse como usuario.
Si es la primera vez que se reporta una idea, el sistema enviará un correo electrónico de
confirmación al autor. Una vez confirmado, la idea será visible en la página principal.
Los autores de ideas recibirán correos electrónicos cada vez que se produzca un evento en su idea: comentarios, archivado, etc.

### Comentar
De manera similar a las ideas, los comentarios necesitan de confirmación por correo electrónico del autor. Un comentario de un miembro de la organización es resaltado sobre el resto.

### Firmar
Firmar una idea convierte al firmante en co-autor, es decir, suscribe al firmante a las mismas notificaciones que el autor.

###Roles:
- *Vecino*: Persona que publica nuevas sugerencias y comentarios.
- *Miembro de la organización*: Se diferencia de un vecino en que sus comentarios son resaltados y
el sistema le permite comentar una vez la sugerencia esta archivada.

### Ciclo de vida de la sugerencia:

1. Una vez una sugerencia es creada por un vecino, se producen **eventos** sobre ella: comentarios, firmas, etc.

2. A los **30 dias del último evento, se envía un correo a todos los firmantes**, informando del número de comentarios negativos que ha tenido y llamandoles a que continuen la conversación para transformar las opiniones negativas en positivas.

3. Si no ha habido respuesta al primer aviso en el plazo de 7 días, **la sugerencia se archiva**: archivar quiere decir que solo pueden añadir comentarios los miembros identificados como de la organización. Una sugerencia archivada sigue siendo visible en la página principal, aunque la cantidad de actividad que recibe será muy limitada.

## Instalación en Desarrollo Linux

### Requisitos
 - Ruby 2.2.2
 - Git
 - Bundler

```bash
$ git clone git@github.com:desarrollolocal/Suggestion_Box.git
$ cd Suggestion_Box/
$ bundle install --without production
$ bundle exec rake db:setup
$ bundle exec rake db:seed
$ bundle exec rails s
```

## Instalación en Heroku
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

### CLI
  - [heroku toolbelt](https://toolbelt.heroku.com/)
  - [Deploy Rails apps in heroku](https://devcenter.heroku.com/articles/getting-started-with-rails4)
  - Addons: [app.json](https://github.com/desarrollolocal/Suggestion_Box/blob/master/app.json)



