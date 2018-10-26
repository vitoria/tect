### How to run

- To run this program, you should install the the following modules by following the commands below.

- Installing `cabal`

```shell
sudo apt install cabal-install
cabal update
```

- Installing `split` module

```shell
cabal install split
```

- Installing `Strict` module

```shell
cabal install Strict
```

- Then, you'll have to import these modules:

```shell
import Prelude hiding (readFile)
import System.IO.Strict (readFile)
```

