# ZeppR

**ZeppR** is an R/Shiny desktop app for data analysis of Zepp body data. The data used for this can be retreived from the Zepp App via Download of a `csv` file. A requirement for a full dataset usable with this application is the use of an amazfit digital body scale. 

## Demo

You can **[watch the demo here on YouTube](https://youtu.be/Q_qFe8FBdOw)** or click the thumbnail below: 

[![ZeppR Demo](https://img.youtube.com/vi/Q_qFe8FBdOw/maxresdefault.jpg)](https://youtu.be/Q_qFe8FBdOw)

## Features

- Import Zepp "BODY" dataset `csv`-file 
- Data cleaning: 
  - remove incomplete measurements
  - remove non-user measurements (e.g. from other family members accidentally associated with the user's account)
- Interactive date-range selection
- Body-composition overview, median analysis and trends for core data:
  - body mass
  - body fat
  - muscle mass
  - water mass
- BMI analysis
- Table view (searchable): 
  - Cleaned data
  - raw-data
- Plots (date-range sensitive): 
  - Visualizations of core metrics (weight, fat, muscle, water)
  - Correlation graphs 

## Project Structure

```text
zeppR/
├── app.R
├── composition_calculations.R
├── data/
│   └── user00/ # sample user data for testing
├── server/
│   ├── server.R
│   ├── dashboard_content.R
│   └── plots.R
├── ui/
│   ├── ui.R
│   ├── dashboard.R
│   └── mydata.R
├── HOWTO.Rmd # Zepp data retrieval - Tutorial
├── README.md # github info file
└── zeppR.Rproj
```

Development files, backups, videos, design material, and non-public data are kept outside the repository through `.gitignore`.

## Data

The repository contains only the `user00` sample dataset used for development and demonstration.

Personal body-composition data and other development data are excluded from version control.

## Running the App

Clone the repository and open `zeppR.Rproj` in RStudio.

Then run:

```r
shiny::runApp()
```

## Dependencies

- `r-base` (backend, plots)
- `shiny` (interactive browser frontend)
- `bslib` (theme)
- `DT` (interactive data tables)
- `ggplot2` (dashboard plots)
- R Markdown (documentation)

## Zepp Data Retrieval

For more information on how to download your personal data from Zepp, check out [`HOWTO.Rmd`](HOWTO.Rmd).

## Add a launcher (Linux only)

To add a launcher, e.g. to a pane, create an empty launcher that leads to the file `zeppR.sh` in the apps root directory containing the following command: 

```bash
#!/bin/bash
R -e "shiny::runApp('.', launch.browser = TRUE)"
```

In the launcher settings, set the working directory to the app's root dir and the command to `./zeppR.sh`. 

Don't forget to make `zeppR.sh` executable using e.g.

```bash
sudo chmod +x zeppR.sh
```

If desired, you can use the icon from the root directory via the image selection option of your launcher menu to customize the button. 

## Status

This project is under active development.

## License 

ZeppR is free and open-source software released under the **GNU General Public License (GPL)**.

There is only one additional requirement:

> **Please pet a kitty. 🐈**

This requirement is, of course, strictly enforced by absolutely no one.

