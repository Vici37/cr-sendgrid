# Crystal Sendgrid

This library provides a client interface to [Sendgrid's mailing API](https://docs.sendgrid.com/api-reference/mail-send/mail-send).

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     sendgrid:
       github: your-github-user/cr-sendgrid
   ```

2. Run `shards install`

## Usage

```crystal
require "sendgrid"


client = Sendgrid::Client.new("SENDGRID_API_KEY")

# `message` is a helper method that will handle the construction of the Sendgrid::Message that gets sent through `send`.
# For the full suite of features the Sendgrid Send Mail API provides, you can use all of the constructs defined
# in ./src/sendgrid/sendgrid_structs.cr directly
message = client.message(
  # The `to` param accepts a single email address, a hash (seen below), or a list of email addresses (strings)
  to: {"Fred Flinstone" => "fred@flinstone.com", "Wilma Flinstone" => "wilma@flinstone.com"},
  # Also accepts a single string for the email, or a named tuple for name, email (below)
  from: {name: "Barny Rubble", email: "barny@rubble.com"},
  subject: "Dino got out again",

  content: "Did you know?"
  )

# Send the email
client.send(message)
```