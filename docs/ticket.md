# Notes on creating tickets

## Ticket File Structure

Tickets are stored in different "domains" in the `docs/tickets` directory. Each
folder under docs/tickets corresponds to a different domain.

For example, if you are working on a ticket related to the "auth" domain, you
would create a ticket file in the `docs/tickets/auth` directory.

## Ticket File Naming

Ticket files should be named in the format `<ticket_id>-<ticket_title>.md`. For
example, if you are working on a ticket with the ID `FT-123` and the title
`Add OAuth2 login support`, you would name the file
`123-add-oauth2-login-support.md`.

Ticket ids should be in the format `FT-XXX`, where `XXX` is a three-digit
number. For example, `FT-123`. They should be unique across all tickets, across
all domains. They should be incrementally assigned.

_Note: `FT` stands for project name "Flake Template"._
