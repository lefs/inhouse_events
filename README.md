![Inhouse logo](inhouse-logo.svg)

Inhouse Events is an event tracking library for web analytics, for Ruby on Rails apps.

## Design Approach

The guiding principle behind this library is "less is more". In some set-ups it could be useful as a simpler alternative to fully featured web analytics solutions. The approach is partly inspired by the [Lean Analytics book](http://leananalyticsbook.com).

## Benefits

The main benefits of this library are:

- Events (currently `pageviews`) are stored in-house, in the application database. This gives you better control of your data.
- The JavaScript used for tracking events is local to the application and would typically not be blocked by ad-blockers.

## Features

After you add the gem to your application and configure it, it will start collecting pageviews in a database table. You could then query these pageviews to perform ad-hoc analysis or you could connect it to a dashboard for a more extensive solution.

## Supported Rails Versions

Currently Rails 4.2 and 5.2 are supported (and by extension Ruby versions from 1.9.3 to 2.6.6).

## Installation

To use the gem add the following line to your application's Gemfile:

```ruby
gem 'inhouse_events'
```

And then execute:

```bash
$ bundle
```

## Configuration

Run the included generator inside your Rails app:

```bash
$ rails g inhouse_events:install
```

This will do 4 things. It will:

1. Place an inhouse_events configuration file at `config/initializers/inhouse_events.rb`:

	```ruby
	InhouseEvents.configure do |config|
	  config.backend_adapter = :active_record
	  config.background_processing_adapter = :active_job
	end
	```
2. Add a `//= require inhouse_events` statement to `application.js`, a line above `//= require_tree .`.

3. Generate an `inhouse_events` migration for the events table.

4. Mount an `InhouseEvents::Engine` to `/inhouse_events` for collecting events.

### Inhouse Events Initializer Config

The configuration in `config/initializers/inhouse_events.rb` is fairly simple. You just need to define your preferred `backend_adapter` and `background_processing_adapter`.

#### Backend Adapter

The `backend_adapter` is responsible for putting event data to your desired destination.

Currently the supported backend adapters are:

* `:active_record` - the default adapter, it saves events to your Rails application's database.
* `:stdout` - directly prints events to the console.

#### Background Processing Adapter

The library requires background processing functionality for handling events asynchronously.

You must specify one of the following adapters in your configuration:

* `:active_job` for [ActiveJob](https://github.com/rails/rails/tree/master/activejob).
* `:sidekiq` for [Sidekiq](http://sidekiq.org).
* `:sucker_punch` for [Sucker Punch](https://github.com/brandonhilkert/sucker_punch).
* `:inline` for testing/development purposes.

You must also add the relevant background processing gem to your Gemfile, for example:

- `gem 'sidekiq'` for `:sidekiq`
- `gem 'sucker_punch'` for `:sucker_punch`

## Usage

This library will save an event for each page viewed in your app. The configuration is the only thing you need to do.

### Muting Events on Selected Pages

You can prevent events from being tracked for a particular page by adding the following line to the template of that page:

```erb
<%= InhouseEvents.ignore_events %>
```

You may also ignore specific event types:

```erb
<%= InhouseEvents.ignore_events(:pageview) %>
```

Until other event types are supported both calls above do the same thing.

## Events

An event object contains various bits of information describing a particular event. Currently only one event type is supported, a pageview. Here is an example `pageview` event:

```json
{
  "page_url": "https://example.com/page",
  "page_title": "An Example Page",
  "referrer_url": "https://search.com",
  "client_timestamp": "2017-03-01T10:15:20Z",
  "client_timezone": -120,
  "client_event_id": "931f9377-f67b-33cb-1ba3-1a5579f82925",
  "event_type": "pageview",

  "ip_address": "8.8.3.3",
  "user": "user@test.org",
  "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12) Firefox/52.0",
  "session_id": "09497d46978bf6f32265fefb5cc52264",
  "server_event_id": "5611abda-bac6-4628-9059-e6e3dfe8c728",
  "server_timestamp": "2017-03-01T10:16:55Z"
}
```

The first part of the object is generated in the browser. Below is a description of each field:

| Name               | Description |
|--------------------|-------------|
| `page_url`         | The URL of the page on which the event occurred. |
| `page_title`       | The title of the page on which the event occurred. |
| `referrer_url`     | The URL of the referring page. |
| `client_timestamp` | The timestamp of the event at the moment it occurred in the browser. Please note that the browser is not guaranteed to have the correct time set. |
| `client_timezone`  | The timezone as set in the visitor's browser. It is expressed as a delta from the UTC. E.g. -60 means UTC+01:00 (Berlin time zone). |
| `client_event_id`  | An event UUID generated in the visitor's browser. |
| `event_type`       | The type of event. Only "pageview" is currently supported. |

Please keep in mind that the above information comes from the browser. There is no way to prevent tampering therefore it should not be trusted to be absolutely correct.

The second part of the object is generated on the server (Rails). Here are the meanings of the fields:

| Name               | Description |
|--------------------|-------------|
| `ip_address`       | The visitor's IP address. |
| `user`             | The user's email or username, whichever is available. This field will be empty for visitors who are not logged in. |
| `user_agent`       | The User Agent string as reported by the visitor's browser. |
| `session_id`       | The unique session identifier generated by Rails. |
| `server_event_id`  | An event UUID generated on the server. |
| `server_timestamp` | The timestamp of the event at the moment it was received on the server. |

## Tests

The library uses [PhantomJS](http://phantomjs.org) to run tests in a headless browser. Please use the tool of your choice for your platform to install it (e.g. `brew` on macOS) or download a binary from the [PhantomJS download page](http://phantomjs.org/download.html).

Additionally, [Appraisal](https://github.com/thoughtbot/appraisal) is used to run tests with various Ruby and Rails versions.

*Important*: Appraisal does not work with standalone bundle installations. The gems should be installed globally or managed via `rbenv` or `rvm gemset`.

To setup the local dependencies for each Rails version defined in Inhouse Events' Appraisals configuration:

```bash
$ bundle
$ bundle exec appraisal install
```

To run the tests for all supported versions of Rails:

```bash
$ bundle exec appraisal rake test
```

In order to run a test for a specific version of Rails (e.g., Rails 4.2) issue:

```bash
$ bundle exec appraisal rails-4-2 rake test
```

To run a single test for a particular Rails version you can issue:

```bash
$ bundle exec appraisal rails-4-2 rspec spec/PATH_TO_TEST_FILE:10
```

To run all tests:

```bash
$ bundle exec rake test
```

## License

Inhouse Events is released under the [MIT License](/LICENSE).
