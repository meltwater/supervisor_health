[![Build Status](https://travis-ci.org/meltwater/supervisor_health.svg?branch=master)](https://travis-ci.org/meltwater/supervisor_health) [![Code Climate](https://codeclimate.com/github/meltwater/supervisor_health/badges/gpa.svg)](https://codeclimate.com/github/meltwater/supervisor_health) [![Test Coverage](https://codeclimate.com/github/meltwater/supervisor_health/badges/coverage.svg)](https://codeclimate.com/github/meltwater/supervisor_health/coverage) [![Issue Count](https://codeclimate.com/github/meltwater/supervisor_health/badges/issue_count.svg)](https://codeclimate.com/github/meltwater/supervisor_health)

# SupervisorHealth

This is the Supervisor Health module for [Elixir][elixir-official] applications. This can be used to provide a health endpoint in a web-based application or API.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Installation](#installation)
- [Usage](#usage)
- [Responses](#responses)
  - [Example](#example)
- [Contact](#contact)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Installation

The package can be installed as following:

  1. Add `supervisor_health` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:supervisor_health, git: "https://github.com/meltwater/supervisor_health", tag: "0.1.0"}]
    end
    ```

  2. Ensure `supervisor_health` is started before your application:

    ```elixir
    def application do
      [applications: [:supervisor_health]]
    end
    ```

## Usage

In an application, e.g. a [Plug][elixir-plug] API, you could use SupervisorHealth like this:

    get "/_health" do
        case SupervisorHealth.health(MyApp.Supervisor) do
            {:ok, resp} -> send_resp(conn, 200, resp)
            {:error, resp} -> send_resp(conn, 500, resp)
        end
    end

## Responses

In general, the library will produce following 2 responses:

- `{:ok, response}` if everything is OK
- `{:error, response}` if any error occurred

The response contains information on any Supervisor child processes.

### Example

Using curl on the [Plug][elixir-plug]-based API mentioned above, a possible response could be:

    $ curl http://localhost:4200/_health | jq .
    {
      "internalProcesses": {
        "{:ranch_listener_sup, MyApp.Http.Router.HTTP}": {
          "status": "waiting",
          "stack_size": 9,
          "reductions": 175,
          "current_function": [
            "gen_server",
            "loop",
            6
          ]
        },
        "MyApp.Database": {
          "status": "waiting",
          "stack_size": 9,
          "reductions": 1136,
          "current_function": [
            "gen_server",
            "loop",
            6
          ]
        }
      },
      "health": "ok"
    }

## Contact

For questions, bug reports and feature requests do not hesitate
to create an [issue on github](https://github.com/meltwater/supervisor_health/issues).

## License

See [License][license].

[blacksmiths-site]: https://github.com/meltwater/blacksmiths-site
[blacksmiths-team-picture-small]: https://github.com/meltwater/blacksmiths-site/blob/master/images/team-picture-small.png
[meltwater-api]: https://wiki.meltwater.net/display/ENG/Meltwater+API
[meltwater-api-architecture]: https://docs.google.com/drawings/d/1vcLqsAYqNh6jUb0_yMS8KVISCMnRPW6-5khsu9DB3jA/edit
[wiki-berlin]: https://wiki.meltwater.net/display/ENG/Berlin
[elixir-official]: http://elixir-lang.org/
[meltwater-official]: https://www.meltwater.com/
[blacksmiths-mission-statement]: https://github.com/meltwater/blacksmiths-site#mission-statement
[blacksmiths-working-agreement]: https://github.com/meltwater/blacksmiths-site#working-agreement
[blacksmiths-guidelines-and-processes]: https://github.com/meltwater/blacksmiths-site#guidelines--processes
[elixir-plug]: https://github.com/elixir-lang/plug
[license]: LICENSE
