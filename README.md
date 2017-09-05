# Run As User

This is an example for how to run Docker containers as the user on the host.

To use this example, mount a volume in your container at /home/myuser. The
entrypoint will automatically adjust permissions of the current user and then
drop down to running as that user, executing the requested command.

```
docker build -t run-as-user .
docker run -it --rm -v $(pwd):/home/myuser run-as-user /bin/bash
```

Inside that container, you can run `id` and `ls -l` to see your permisisons
matching that of /home/myuser.

