# Software is reproducible with docker

Here is a simple Dockerfile that installs Python and runs a script:

```dockerfile
FROM bitnami/minideb


COPY script.py /app/script.py
RUN python /app/script.py
```

Suppose `script.py` just prints the Python version:

```python
import sys
print(sys.version)
```


# But actually it's not

If you rebuild this Docker image at different times, you might get different results because the `python:3.10-slim` image can change over time. For example, the output of `sys.version` could be different if the base image updates.

This means the environment is not truly reproducible.


# Nix solves it:

With Nix, you can pin exact dependencies and get the same result every time. Here is a `shell.nix` that ensures reproducibility:

```nix
{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = [ pkgs.python310 ];
}
```

Now, running `python script.py` inside this shell will always use the exact same Python version, as specified by the Nixpkgs revision.



