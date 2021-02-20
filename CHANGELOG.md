# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- URIs are now parsed using `Addressable::URI#heuristic_parse` instead of `Addressable::URI#parse`
  to more robustly handle URIs that can be specified in configuration. The coercion, contrary to
  the default behaviour of `Addressable::URI#heuristic_parse` does not assume `http` as the default.
  If the scheme is neither hinted at or specified in the URI, the scheme will be `nil` and the resulting
  URI will be scheme-relative. If you prefer to assume a scheme, specify it explicitly,
- `Types::URI` is now a type constructor, `Types.URI`. The constructor optionally accepts any
  URI parsing hints `Addressable::URI#heuristic_parse` accepts.

## [0.4.1] - 2020-12-03
### Changed
- Relaxed `dry-types` constraint to `~> 1.0`.

## [0.4.0] - 2020-12-03
### Changed
- Updated `dry-types` constraint to `~> 1.0.0`.

## [0.3.0] - 2020-12-03
### Changed
- Updated `dry-types` constraint to `~> 0.15.0`.

## [0.2.1] - 2020-12-03
### Added
- Configurations can now opt-in to all settings being required-by-default with `required_by_default!`.

## [0.2.0] - 2020-05-19
### Added
- Configurations can now be protected from unwanted changes by calling `#finalize!` on them,
- Loader instance can now be queried for the loaders it's configured with using `#loaders`,
- Configuration can now be converted to a hash using `to_h`.

## [0.1.0] - 2020-05-12
### Added
- Initial release.

[Unreleased]: https://github.com/surgeventures/fig/compare/v0.4.1...HEAD
[0.4.1]: https://github.com/surgeventures/fig/releases/tag/v0.4.1
[0.4.0]: https://github.com/surgeventures/fig/releases/tag/v0.4.0
[0.3.0]: https://github.com/surgeventures/fig/releases/tag/v0.3.0
[0.2.1]: https://github.com/surgeventures/fig/releases/tag/v0.2.1
[0.2.0]: https://github.com/surgeventures/fig/releases/tag/v0.2.0
[0.1.0]: https://github.com/surgeventures/fig/releases/tag/v0.1.0
