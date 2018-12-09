# simple-mail-parser

A quick and dirty Crystal email parser.

Port of <https://github.com/jaronson/simple_mail_parser>.

## Installation

1. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  simple-mail-parser:
    github: larskluge/simple-mail-parser.cr
```
2. Run `shards install`

## Usage

```crystal
require "simple-mail-parser"

eml = "To: foo@bar.com\r\nContent-Type: text/plain\r\n\r\nHello"
message = SimpleMailParser.parse(eml)
message.to.should eq "foo@bar.com"
message.body.should eq "Hello"
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/larskluge/simple-mail-parser.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Lars Kluge](https://github.com/larskluge) - creator and maintainer
