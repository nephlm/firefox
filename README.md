# firefox
container to firefox under purevpn via vnc

## Customize

Add username/pw and desired country.

```
cp purevpn.env.sample purevpn.env
vim purevpn.env
```

## Build

```
./tools/build
```

## Run

```
docker-compose up
```

To access the desktop:

```
vinagre localhost:5900
```