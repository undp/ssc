# UNDP SSC Mapping and data explorer

Based on a subset of data from http://open.undp.org, presents and maps additional attributes specific to South-South Cooperation.

## Contents

* See [below](#user-manual) for basic information about using the application
* See [`manage.md`](docs/manage.md) for administrators to manage data
* See [`data.md`](docs/data.md) for information on fields and data models
* See [`deploy.md`](docs/deploy.md) for deployment
* See [`admin_scripts`](admin_scripts/README.md) for admin scripts used for initial data processing (not production use)

## User manual

The application is designed to be used without requiring a manual. This document is to help administrators and managers point users in the right direction, and also to outline the application's functionality.


### Downloading

The [`projects.csv` file](http://localhost:4000/api/projects.csv) contains all data about all projects. Many of the columns/fields are encoded, but should be clearly understood. For reference, 

#### Partner
Short | Full 
---|---
`international_cooperation_development_agencies` | International cooperation / development agencies
`regional_inter_governmental_organizations` | Regional / Inter-governmental organizations
`national_governments` | National governments
`sub_national_governments` | Sub-national governments
`cso` | CSO
`academia` | Academia
`private_sector` | Private sector

#### Region
Short | Full
---|---
`lac` | Latin America & Caribbean
`africa` | Africa
`asia_pacific` | Asia & Pacific
`arab_states` | Arab States
`europe_cis` | Europe & CIS

#### Thematic focus
Short | Full
---|---
`sustainable_development_pathways` | Sustainable development pathways
`resilience_building` | Resilience building
`inclusive_and_effective_democratic_governance` | Inclusive and effective democratic governance

#### UNDP Role
Short | Full
---|---
`builder_of_capacities` | Builder of capacities
`knowledge_broker` | Knowledge broker
`facilitator_of_partnerships` | Facilitator of partnerships

#### Territorial focus
Short | Full
---|---
`mic` | Middle Income Countries
`sids` | Small Island Developing States
`fragile_states` | Fragile States
`ldc` | Least Developed Countries
`hic` | High Income Countries

#### Scale
Short | Full
---|---
`global` | Global
`regional` | Regional
`national` | National


