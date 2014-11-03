# Dough

The Money Advice Service's frontend assets.

[![Code Climate](https://codeclimate.com/github/moneyadviceservice/dough/badges/gpa.svg)](https://codeclimate.com/github/moneyadviceservice/dough)

## Prerequisites

* [Git]
* [Bower]
* [NodeJS]
* [Grunt]

## Installation

Clone the repository:

```sh
$ git clone https://github.com/moneyadviceservice/dough.git
```

Make sure all dependencies are available:

```sh
$ bower install
$ npm install
```

## How to use a local copy of Dough

**Dough is a bower module embedded inside a ruby gem.**

Use these instructions when you're working on Dough and want to
see the effects within another project. For example, if you're working on _Pension Calculator_,
you want to use a local copy of Dough.

For the purpose of this example, _PROJECT_ refers to _Pension Calculator_, or whatever you're working on.

#### Make sure you have the latest bundle in _PROJECT_

```sh
cd PROJECT
bundle install
```

#### Link `dough-ruby` to your local copy, in _PROJECT_'s `Gemfile`

***DO NOT COMMIT THIS!!!***

```sh
# Add this to the top of the file if it doesn't exist already
gem 'dough-ruby', path: '~/Sites/dough' # or whatever your local Dough is
```

#### Set up `bower link` in Dough

```sh
cd ~/Sites/dough # or whatever your local Dough is
bower link
```

#### Connect the link above to _PROJECT_

```sh
cd PROJECT
bower link dough
```

#### Troubleshooting

If you don't see your local CSS after following the steps

```sh
rm -r tmp/cache
```

## Running Javascript tests

Make sure you ran npm install.

```sh
$ ./node_modules/karma/bin/karma start test/karma.conf.js --single-run
```

## Javascript style checking

Make sure you ran npm install.
```
./node_modules/jshint/bin/jshint ./assets/js --config .jshintrc
```

```
./node_modules/jscs/bin/jscs js
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Keep your feature branch focused and short lived
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request


[bower]: http://bower.io
[git]: http://git-scm.com
[nodejs]: http://nodejs.org/
[grunt]: http://gruntjs.com/getting-started

## Releases
31/7/14 - v1.0.0 - breaking change - VisibilityToggler component renamed to Collapsable
