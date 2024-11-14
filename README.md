# clas12-validation

[![Validation Status](https://github.com/JeffersonLab/clas12-validation/actions/workflows/ci.yml/badge.svg)](https://github.com/JeffersonLab/clas12-validation/actions/workflows/ci.yml)

Automated validation of CLAS12 offline software using GitHub Continuous Integration (CI). The following repositories are tested:
- [`coatjava`](https://github.com/JeffersonLab/coatjava)
- [`gemc`](https://github.com/gemc), namely [`clas12Tags`](https://github.com/gemc/clas12Tags)
- [`clas12-config`](https://github.com/JeffersonLab/clas12-config)
- this repository itself

## Configuration

The [workflow](.github/workflows/ci.yml) is reusable: it can be called by other workflows as
```yaml
jobs:
  validation:
    uses: JeffersonLab/clas12-validation/.github/workflows/ci.yml@main
```

You may customize the called workflow with `input` variables; for technical reasons, the default
values and their description are found in [the workflow file](/.github/workflows/ci.yml) in the `env:`
section. Below is an example how to set some of them:
```yaml
jobs:
  validation:
    uses: JeffersonLab/clas12-validation/.github/workflows/ci.yml@main
    with:
      # use a custom number of events, rather than the defaults:
      num_events: 8
      # use a custom list of event generation types to run
      matrix_evgen: >-
        [
          "e_K",
          "e_n",
          "e_g"
        ]
      # use a custom list of config files to run
      matrix_config: >-
        [
          "rga_spring2018",
          "rgb_fall2019"
        ]
      # use specific fixed versions of the config files, rather than the default (latest) versions (JSON string):
      config_file_versions: >-
        {
          "coatjava": "10.0.0",
          "gemc":     "5.3"
        }
      # use a specific fork and ref (e.g., branch, commit, tag) of certain repositories (JSON string);
      # if 'ref' is an empty string, the highest semantic-versioned tag will be used
      git_upstream: >-
        {
          "coatjava":      { "fork": "UserName/coatjava",          "ref": "feature-branch"   },
          "clas12-config": { "fork": "JeffersonLab/clas12-config", "ref": "new-config-files" }
        }
      # choose which GEMC version to use
      gemc_version: match_gcard
```

## Version Handling

`clas12-validation` supports certain version combinations, with versions of the upstream repositories (`clas12Tags`, `coatjava`, _etc_.) and
versions of the configurations (`gcard` files for `gemc`, and `yaml` files for `coatjava`). Depending on the triggering workflow and trigger
branch, `clas12-validation` needs to choose the most appropriate combination of version numbers.

First of all, the input variable `matrix_config` (see configuration, above) lists the configuration file (`gcard` and `yaml`) _basenames_ that are tested; for each of these,
we test simulation and reconstruction using _each_ event generator sample defined by `matrix_evgen`.

In many cases we test on the latest `gcard` for a given basename, but we need to make sure the `gemc` version that is used _matches_ the `gcard` version.
The latest version of a `gcard` (or `yaml`) file for a given basename is determined by finding all of the `gcard` (or `yaml`) files with that
basename, and choosing the one in the subdirectory corresponding to the highest semantic version number.
Other cases, for example `clas12Tags` triggers, may use a new CI build of `clas12Tags` (`gemc`), together with the `dev` version of the `gcard`.

The following table shows the configuration file versions and repository versions, for various upstream triggering repositories.

> [!NOTE]
> This table may not be up-to-date! Check the repositories' CI configurations for the actual versions used.

| Triggering Repository                     | `clas12-config` branch | `clas12Tags` branch | `gcard` version | `yaml` version     | `gemc` version      | `coatjava` version |
| ---                                       | ---                    | ---                 | ---             | ---                | ---                 | ---                |
| `clas12-validation`                       | `main`                 | N/A                 | latest          | latest<sup>1</sup> | `gcard`<sup>2</sup> | `development`      |
| `coatjava`                                | `main`                 | N/A                 | latest          | latest<sup>1</sup> | `gcard`<sup>2</sup> | triggering version |
| `clas12Tags`                              | `dev`                  | triggering version  | `dev`           | latest             | CI build            | latest             |
| `clas12-config`, `dev` branch<sup>3</sup> | triggering version     | `dev`               | `dev`           | latest             | CI build            | `development`      |
| `clas12-config`, any other branch         | triggering version     | N/A                 | latest          | latest<sup>1</sup> | `gcard`<sup>2</sup> | `development`      |

> 1. the latest `yaml` version that _is compatible_ with the `gcard` version.
> 2. use the `gcard` version to `module switch` to the corresponding `gemc` version
> 3. or any PR branch that _targets_ the `dev` branch

## Legacy Version
The original version of this repository is found in [release `v0.1`](https://github.com/JeffersonLab/clas12-validation/releases/tag/v0.1).
