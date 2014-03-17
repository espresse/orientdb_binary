# Orientdb Binary

OrientDB Network Binary library for Ruby.

## Installation

Add this line to your application's Gemfile:

    gem 'orientdb-binary'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install orientdb-binary

## Usage

OrientDB operates on two levels - server level, with actions like database creation/deletion and config settings and database level, where operations on database instance occures.

### Server actions ###

First, you need to connect to OrientDb Server socket.

```
connection = OrientdbBinary::Connection.new(host: 'localhost', port: 2424)
```

Next connect to server instance, providing OrientDb's root user credits.

```
server = connection.server(user: 'root', password: 'root')
```

#### Database ####

Start with defining database name, its storage (choose from :memory, :plocal and :local, refer to OrientDB's documentation to choose the proper one) and type (:graph or :document)

```
database = server.database.new(name: 'test', storage: :memory, type: :graph)
```

Check database existance:

```
database.exists?
```

If it doesn't then maybe it's a good time to create it?

```
database.save!
```

If you'd like to remove it:

```
database.drop!
```

You can list all databases if you wish. This command returns a hash with databases names as keys and storage information as values.

```
server.database.list
```

#### Configuration ####

Working with server configuration is easy as well.

```
config = server.config
```

You can fetch a list of all configurations with

```
config.list
```

If you know the name you can fetch one config value

```
config.get(name)
```

Set up new config value with simple

```
config.set(name, value)
```

## Contributing

1. Fork it ( http://github.com/espresse/orientdb-binary/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
