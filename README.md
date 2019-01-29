# PTFE Module Updater

  Simple bash script utilizing the PTFE (Private Terraform Enterpise) API to create, version and upload Terraform modules to the PTFE Private Module Registry.

- The script uses the current module folder name as the name for the module to be uploaded.
- A version number is required for the module.
  - If the module is new, the script automatically versions the module as "1.0.0"
- The script creates a temporary *.tar.gz file to upload the files to module registry and removes the archive on script exit.

## Getting Started

### Dependencies

- bash 3.2+
- Your PTFE Org Information:
  - PTFE User Token
  - Organization Name
    - "eg. MARKBIXLER"
  - Module Provider
    - "eg. MB"
  - ** These values manually entered in the script or set as ENV variables **

### Installing

- Clone / Download source code.
- Copy *moduleUploder.sh* into module directory

### Executing program

- Set $TOKEN environment variable

  - `export TOKEN=aFoFQ4nLtgkA19g.atlasv1....`

- Run moduleUploader.sh
  ​
  `./moduleUploader.sh​`

- You can also run the command with the **TOKEN** as an argument

  `./moduleUploader.sh TOKEN=aFoFQ4nLtgkA19g.atlasv1....`

## Help

`moduleUploader.sh -h`

## Authors

Mark Bixler  
mark.bixler@mindbodyonline.com

## Version History

- 0.1
  - Initial Release