# Tang Container

## Maintainer

- [Alexandre Chanu](https://github.com/achanu)

## Build
* podman build -f Dockerfile -t tang

## Usage
* mkdir $(pwd)/tang_key
* podman run -d -p 7050:7050 -v $(pwd)/tang_key:/var/db/tang tang
* echo "Hello World..." | clevis encrypt tang '{ "url": "http://localhost:7050"}' > secret.jwe
* clevis decrypt < secret.jwe

## Original idea from
- [Adrian Lucrèce Céleste](https://github.com/AdrianKoshka)

## Enhanced with ideas from
- [Nathaniel McCallum](https://github.com/npmccallum)
- [Michel Belleau](https://github.com/malaiwah)
- [bstin](https://github.com/bstin)
- [Scott McCarty](https://github.com/fatherlinux) for micro version

## [License](LICENSE)

[GPLv3](LICENSE)
