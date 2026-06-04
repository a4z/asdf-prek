<div align="center">

# asdf-prek [![Build](https://github.com/a4z/asdf-prek/actions/workflows/build.yml/badge.svg)](https://github.com/a4z/asdf-prek/actions/workflows/build.yml) [![Lint](https://github.com/a4z/asdf-prek/actions/workflows/lint.yml/badge.svg)](https://github.com/a4z/asdf-prek/actions/workflows/lint.yml)

[prek](https://github.com/j178/prek) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add prek
# or
asdf plugin add prek https://github.com/a4z/asdf-prek.git
```

prek:

```shell
# Show all installable versions
asdf list-all prek

# Install latest version
asdf install prek latest

# Set a version globally (on your ~/.tool-versions file)
asdf set -u prek latest

# Now prek commands are available
prek --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/a4z/asdf-prek/graphs/contributors)!

# License

See [LICENSE](LICENSE)
