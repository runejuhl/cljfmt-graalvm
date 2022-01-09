# `cljfmt-graalvm`

A Clojure code formatter using cljfmt built with [`graalvm`](https://github.com/oracle/graal/).

## Usage

```sh
./cljfmt [-c|--config CONFIG] [-t|--test] source-file.clj
```

## Build

### Using Docker

The repo contains a `Makefile` with a recipe for building a `cljfmt` binary
using GraalVM inside a Docker image:

```sh
make build/docker
```

The Docker image used is `runejuhl/lein-graal`. A `Dockerfile` can be found at
https://github.com/runejuhl/dockerfiles#lein-graal.

### By hand

For linux, a binary may be downloaded directly from [Gitlab](https://gitlab.com/konrad.mrozek/cljfmt-graalvm/-/jobs/artifacts/master/download?job=build).
To build the binary yourself, here are some instructions.

- Install [lein](https://leiningen.org/)
- Download [GraalVM](http://www.graalvm.org/downloads/) for your machine. You
  will need the EE version if you're using MacOS.
- Set `JAVA_HOME` to the GraalVM home directory, e.g.

```sh
export JAVA_HOME=~/Downloads/graalvm-1.0.0-rc1/Contents/Home
```

- Set the `PATH` to use GraalVM's binaries, e.g.

```sh
export PATH=$PATH:~/Downloads/graalvm-1.0.0-rc1/Contents/Home/bin
```

- Create the uberjar:

```sh
lein uberjar
```

- Finally, create the binary:

``` sh
native-image -jar target/cljfmt-graalvm-0.1.0-SNAPSHOT-standalone.jar -H:Name="cljfmt"
```

## Integrate with Emacs

Place the `cljfmt` binary on your `PATH`. To execute it on a Clojure file in
Emacs on save, add this to your `init.el`:

```elisp
(defun cljfmt ()
  (when (or (eq major-mode 'clojure-mode)
            (eq major-mode 'clojurescript-mode))
    (shell-command-to-string (format "cljfmt %s" buffer-file-name))
    (revert-buffer :ignore-auto :noconfirm)))

(add-hook 'after-save-hook #'cljfmt)
```

If using `use-package` the following package configuration can be used. It uses
`projectile-locate-dominating-file` to automatically find the closest
`.cljfmt.edn` file.

```elisp
(use-package clojure-mode
  :straight t
  :config
  (defun runejuhl:cljfmt ()
    "Based on
https://www.reddit.com/r/Clojure/comments/8gkmxa/clojure_formatter_using_cljfmt_built_with/dyeix74/"
    (if-let* ((config-file-dir (projectile-locate-dominating-file buffer-file-name ".cljfmt.edn"))
              (config-file (concat (file-name-as-directory config-file-dir) ".cljfmt.edn")))
        (shell-command-to-string (format "cljfmt -c %s %s" config-file buffer-file-name))
      (shell-command-to-string (format "cljfmt %s" buffer-file-name)))
    (revert-buffer :ignore-auto :noconfirm))

  :hook
  ((clojure-mode
    . (lambda ()
        "Add a buffer-local after-save hook to run cljfmt."
        (add-hook 'after-save-hook #'runejuhl:cljfmt nil t)))))
```

## License

Distributed under the Eclipse Public License either version 1.0 or (at your
option) any later version.
