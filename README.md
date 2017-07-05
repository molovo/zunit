![ZUnit](https://zunit.xyz/img/logo.png)

[![Build Status](https://travis-ci.org/molovo/zunit.svg?branch=master)](https://travis-ci.org/molovo/zunit) [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/molovo/zunit?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

ZUnit is a powerful unit testing framework for ZSH

## Installation

> **WARNING**: Although the majority of ZUnit's functionality works as expected, it is in the early stages of development, and as such bugs are likely to be present. Please continue with caution, and [report any issues](https://github.com/molovo/zunit/issues/new) you may have.

### [Zulu](https://github.com/zulu-zsh/zulu)

```sh
zulu install zunit
```

> **NOTE:** In versions of Zulu prior to `1.2.0`, there is an additional step required after install:

  ```sh
  cd ~/.zulu/packages/zunit
  ./build.zsh
  zulu link zunit
  ```

### [Homebrew](http://brew.sh)

```sh
brew tap molovo/revolver https://github.com/molovo/revolver
brew tap molovo/zunit https://github.com/molovo/zunit
brew install zunit # [--devel|--HEAD]
```

### Manual

```sh
git clone https://github.com/molovo/zunit
cd ./zunit
./build.zsh
chmod u+x ./zunit
cp ./zunit /usr/local/bin
```

> ZUnit requires the utilities [Color](https://github.com/molovo/color) and [Revolver](https://github.com/molovo/revolver) to be installed, and in your `$PATH`. The zulu installation method will install these dependencies for you.

## Writing Tests

### Test syntax

Tests in ZUnit have a simple syntax, which is inspired by the [BATS](https://github.com/sstephenson/bats) framework.

```sh
#!/usr/bin/env zunit

@test 'My first test' {
	# Test contents here
}
```

The body of each test can contain any valid ZSH code. The zunit shebang `#!/usr/bin/env zunit` **MUST** appear at the top of each test file, or ZUnit will not run it.

## Documentation

For a full breakdown of ZUnit's syntax and functionality, check out the [official documentation](https://zunit.xyz/docs/).

## Contributing

All contributions are welcome, and encouraged. Please read our [contribution guidelines](contributing.md) and [code of conduct](code-of-conduct.md) for more information.

## License

Copyright (c) 2016 James Dinsdale <hi@molovo.co> (molovo.co)

ZUnit is licensed under The MIT License (MIT)

## Team

* [James Dinsdale](http://molovo.co)
