# Fonemas

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'fonemas'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fonemas

## Usage

    require 'fonemas'
    fonemas = Fonemas.fonemas('abuela')
    puts fonemas.join('\n')

Also you can use it from the command line:

    fonemas wordlist.txt

or print the phonem list:

    fonemas --list

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
