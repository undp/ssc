# Admin scripts

A couple of scripts for initial configuration. They're not part of the ongoing maintenance of projects data. Ongoing maintenance does not require any scripts being run on the server - it's all done through the online admin interface and Prose.io (see [here](../docs/manage.md))


### Requirements 

**Cleaning and preparing data:**

- [OpenRefine](http://openrefine.org)

**Running the scripts:**

- [nodeJS and npm](http://nodejs.org)
- [coffeescript](http://coffeescript.org)

## Generate Prose config for `_config.yml`

In the `admin_scripts` folder, run `npm install && coffee generate_prose_config`. This will repopulate the Jekyll `_config.yml` file with the correct configuration for Prose.io. This is necessary to keep the configuration of the Prose interface in sync with the filters and indices used in the app.


## UNDP SSC data initial data processing

This document outlines the steps taken to go from an Excel file of all the projects, to an initial set of individual project files. It's not intended that this process is repeated, it's included for reference and as an 'audit trail'.


### Steps
1. Take Excel file containing all projects, denormalised (e.g. `source/Programme Mapping Master file_FINAL_for JS_edited 20 01 15.xlsm`)
2. Copy and paste required cells to new sheet, to lose the macros and other extra content which stop it importing in next step.
3. Create new [OpenRefine](http://openrefine.org) project (will need to have OpenRefine installed and running), and import the Excel file.
4. Apply lots of processing and cleaning steps! The ones used so far are in `open_refine_steps.json`, but these may not be relevant to a different Excel file. (See below for a summary of the steps).
)
5. Export from OpenRefine to `refine_projects_export.json`
6. Run `cd admin_scripts && coffee create_project_files.coffee`


## Summary of OpenRefine processing

1. Create arbitrary project_id based on hash of project title and project objective
2. Clean up country, region, etc columns to catch inconsistent spellings.
3. Split Objective into Objective and Description
4. Combined lines where multiple SSC activities relate to the same project ID
5. Flagged lines for manual checking


## JSON exchange structure for OpenRefine export / processing import
```
    {
      # IDs
      "project_id"        : project.project_id,
      "open_project_id"   : project.open_project_id,

      # Project description
      "project_title"     : project.project_title,
      "project_objective" : project.project_objective,
      "scale"             : project.scale,
      "country"           : project.location,
      "region"            : project.region,

      # SSC intervention
      "undp_role_type"    : project.undp_role_type,
      "thematic_focus"    : project.thematic_focus,
      "ssc_description"   : project.ssc_description,
      "territorial_focus" : project.territorial_focus,
      "partner_type"      : project.partner_type,

      # Links
      "project_link"      : project.project_link
    }
```

### Helping hands

`fswatch -0 ~/Downloads/SSC_additional_data_June_2015.txt | xargs -0 -n1
-I'{}' mv '{}' .` watches the Downloads folder for the next export, and
moves into the right folder for processing. Useful while refining the
field naming and import process.
