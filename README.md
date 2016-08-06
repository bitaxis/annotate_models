# annotate_models

This is my own re-write of an earlier version [ctran/annoate_models](https://github.com/ctran/annotate_models) when
work on it waned.  This work started out as a Rails plugin; I am now re-bundling it as a gem since plugin support for Rails has
long been deprecated.

## Installation

If you are using Bundler, add this line to your Gemfile:

```ruby
gem "annotate_models"
```

Otherwise, run this command:

```
gem install annotate_models"
```

## Usage

Run this command from the root folder of your Rails application:

```
rake annotate
```

For details, run ```rake -T```.

## Credit

I first learned to love the functionality of Dave Thomas' annotate_models plugin (you can find a repo for it
[here](https://github.com/alsemyonov/annotate_models)).  Later, when it became un-maintained and broke, I switched over to
[ctran/annoate](https://github.com/ctran/annotate_models).  Then, when work on it waned and broke as well, I decided to write my own
as an exercise.

So thanks go out to Pragmatic Dave as well as to the author and contributors of ctran/annotate_models.

## Contribution

Feel free to fork or clone this repository.

## Workflow

To build the gem, execute these commands:

```
gem build annotate_models.gemspec
mv annotate_models-*.gem pkg/
```

To publish the gem, execute this command:

```
gem push pkg/annotate_models-<version>.gem
```
