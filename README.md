# Marker

## What is Marker?

Marker is a lightweight bookmark manager, with optional support for archiving
web pages using an external backup/archival backend.

## Features

- [x] Saving and managing bookmarks.
- [x] Organizing bookmarks via tags.
- [x] Optional support for archiving pages using Shiori. To use, make sure to
      add the connection info to `config/` --- using Shiori inside of a
      stateful container is probably the easiest approach.
- [x] Multi-user support.

## Roadmap

- [ ] Alternative archival backends. User should be able to choose to use one or
      more of these.
- [ ] Intelligent search, including filtering by tags and domain.
- [ ] Full text search on bookmarks / archives.
- [ ] Multi-user support for archival backends (will depend on specific backend
      support).
- [ ] Convenient reading of archives inside of Marker. (Likely will require
      forwarding/proxying requests to the specific archival backend).
