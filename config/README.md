# Validation Configuration Files

## CI Configuration

The following `json` files are used for configuring the CI job matrix and other options:

| File              | Purpose                                                       |
| ---               | ---                                                           |
| `evgen_opts.json` | options for event generation script                           |
| `evgen_ci.json`   | CI job matrix for event generation                            |
| `config_ci.json`  | CI job matrix for simulation and reconstruction configuration |

The CI matrices are hard-coded here, to keep the number of workflow jobs minimal but still broad.

Use [`../bin/match_configs.rb`](../bin/match_configs.rb) to get a list of all configuration files from `clas12-config` versions, _e.g._,
```bash
CLAS12CONFIG=/path/to/clas12-config
../bin/match_configs.rb $CLAS12CONFIG/coatjava/10.0.2 $CLAS12CONFIG/gemc/5.4
```
returns
```json
{
  "config": [
    "clas12-default",
    "rga_fall2018",
    "rga_spring2018",
    "rga_spring2019",
    "rgb_fall2019",
    "rgb_spring2019",
    "rgc_summer2022_Elmo",
    "rgc_summer2022_FTOn",
    "rgk_fall2018_FTOff",
    "rgk_fall2018_FTOn"
  ]
}
```
(this was piped through `jq` for pretty printing, and results may differ from the current version of `clas12-config`).
