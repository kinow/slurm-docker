
Building

```bash
$ docker build -t slurm:test .
$ docker run --name slurm --hostname docker --rm -d -p 2222:22 slurm:test
```

Accessing

```bash
$ docker exec -ti slurm /bin/bash
```

or

```bash
$ ssh -p 2222 testuser@localhost
```
