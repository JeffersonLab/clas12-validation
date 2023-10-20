# clas12-validation

[![Validation Status](https://github.com/JeffersonLab/clas12-validation/actions/workflows/ci.yml/badge.svg)](https://github.com/JeffersonLab/clas12-validation/actions/workflows/ci.yml)

Automated validation of CLAS12 offline software using GitHub Continuous Integration (CI). The following repositories are tested:
- [`coatjava`](https://github.com/JeffersonLab/coatjava)
- [`gemc`](https://github.com/gemc), namely [`clas12Tags`](https://github.com/gemc/clas12Tags)
- [`clas12-config`](https://github.com/JeffersonLab/clas12-config)

The [workflow](.github/workflows/ci.yml) is reusable: it can be called by other workflows as
```yaml
jobs:
  validation:
    name: dispatch validation
    uses: JeffersonLab/clas12-validation/.github/workflows/ci.yml@main
```

You may customize the called workflow with `input` variables; in general, they override the `env` variables. Here is an example which describes and uses all of them:
```yaml
jobs:
  validation:
    name: dispatch validation
    uses: JeffersonLab/clas12-validation/.github/workflows/ci.yml@main
    with:
      # use a custom number of events, rather than the defaults:
      num_events: 8
      # use specific fixed versions of the config files, rather than the default (latest) versions (JSON string):
      config_file_versions: >-
        {
          "coatjava": "10.0.0",
          "gemc":     "5.3"
        }
      # use a specific fork and branch of certain repositories (JSON string):
      git_upstream: >-
        {
          "coatjava": { "fork": "UserName/coatjava", "branch": "feature-branch" },
          "clas12-config": { "fork": "JeffersonLab/clas12-config", "branch": "new-config-files" }
        }
```

### Legacy Version
The original version of this repository is found in [release `v0.1`](https://github.com/JeffersonLab/clas12-validation/releases/tag/v0.1).
