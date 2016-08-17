# docker-phpcs-drupal

## How to use
Go to needed module or file
```
cd /path/to/check
```
By default we call phpcs from container
```
docker run --rm -v $(pwd):/work docker-phpcs-drupal ./
```

To call phpcbf you need rewrite entrypoint directive
```
docker run --rm -v $(pwd):/work --entrypoint=phpcbf docker-phpcs-drupal --standard=Drupal ./
```
