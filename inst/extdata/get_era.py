# mamba env create -f get_era_ee.yml 
# mamba activate get-era-ee
# python get_era_ee.py > log_ee.txt

import ee
import xarray as xr
import numpy as np

ee.Initialize(project="ee-sylvainmschmitt", opt_url='https://earthengine-highvolume.googleapis.com')
ic = ee.ImageCollection("ECMWF/ERA5_LAND/HOURLY").filter(ee.Filter.date('2023-01-01', '2023-12-31'))
pt = ee.Geometry.Point(3.70, 50.2)
ds = xr.open_mfdataset([ic], engine='ee', projection=ic.first().select(0).projection(), geometry=pt, fast_time_slicing=True)
ds['tas'] = ds['temperature_2m'] - 273.15
# ds['time'] = ds['time'] - 3*60*60*10**9
ds = ds[['tas']]
ds_df = ds.to_dataframe()
ds_df.to_csv("era.tsv", sep="\t", index=True)
