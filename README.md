# transmission

Container to run transmission under purevpn vpn.

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

Web interfaces should be at http://localhost:9091/
