# mamba env create -f fft.yml

import numpy as np
import datetime as dt
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

from scipy.fft import rfft, rfftfreq

### Data preparation ### 

# Load Hobo temperature:
hobo_raw = pd.read_csv('hobo.tsv',sep='\t')
## Convert datetime column to datetime object
hobo_raw['datetime'] = hobo_raw['datetime'].apply(lambda x: dt.datetime.strptime(x,'%Y-%m-%dT%H:%M:%SZ'))
## Slice datetime/t_hobo
hobo = hobo_raw[['datetime','t_hobo']]

# load ERA temperatue:
era_raw = pd.read_csv('era.tsv',sep='\t')
## Convert time column to datetime object
era_raw['datetime'] = era_raw['time'].apply(lambda x: dt.datetime.strptime(x,'%Y-%m-%d %H:%M:%S'))
## Slice datetime/t_hobo
era = era_raw[['datetime','tas']]
# rename the temp. column
era = era.rename(columns={"tas": "t_era"})

# Merge data

data = hobo.merge(era,on='datetime',how='inner',sort=True)

## Check hours that are lacking
print('Index of data which are lacking:')
for i in range(len(data.index)-1):
    if (data['datetime'][i+1]-data['datetime'][i]).seconds > 3600:
        print(i)

print('\nHere is a problem at summer time? To discuss!')
print(data.iloc[2015:2020,:])
data.iloc[2018,0] = data.iloc[2018,0] - dt.timedelta(seconds=3600)
print('\nAfter correction:')
print(data.iloc[2015:2020,:])

print('\nHere is lacking 10 hours:')
print(data.iloc[6920:6930,:])
print('We do nothing for the moment, to discuss!')

print('\nData are ready.')

## For sake of simplicity index the pandas frame by datetime

data = data.set_index('datetime')

### FFT CODE ###

def mcr_fft(date1,date2,data):
    """ The function return the fourier coefficient of t_hobo and t_era within data from date1 to date 2 """

    # slice the data and convert to numpy array
    t_hobo_series= data.loc[date1:date2]['t_hobo'].to_numpy()
    t_era_series= data.loc[date1:date2]['t_era'].to_numpy()

    # Real FFT
    fhobo = rfft(t_hobo_series)
    fera  = rfft(t_era_series)

    return fhobo,fera

# Test on 5 days

date1 = dt.datetime(2023,7,2,0)
date2 = dt.datetime(2023,7,6,23)

fhobo, fera = mcr_fft(date1,date2,data)

N = 5*24 #number of samples

## We plot the power spectrum
plt.semilogy(rfftfreq(N),2/N*np.abs(fhobo),'tab:green',label='Hobo')
plt.semilogy(rfftfreq(N),2/N*np.abs(fera),'tab:orange',label='ERA')

## In abscissa we represent the period instead of frequencies, and we select some relevant one, variation on 24h, 12h, 8h, 6h, 4h and 3h
plt.xticks([0,1/24,1/12,1/8,1/6,1/3],['0','24','12','8','6','3'])
plt.vlines(0,0.0001,100,colors='tab:grey',linestyles='--')
plt.vlines(1/24,0.0001,100,colors='tab:grey',linestyles='--')
plt.vlines(1/12,0.0001,100,colors='tab:grey',linestyles='--')
plt.vlines(1/8,0.0001,100,colors='tab:grey',linestyles='--')
plt.vlines(1/6,0.0001,100,colors='tab:grey',linestyles='--')
plt.vlines(1/4,0.0001,100,colors='tab:grey',linestyles='--')
plt.vlines(1/3,0.0001,100,colors='tab:grey',linestyles='--')

plt.ylabel('Power')
plt.xlabel('Period (in h)')
plt.legend()

plt.title('Representation of power spectrum (window 5days)')
plt.show()


# This is the core function wich return selected frequencies over a period

def mcr_fft2(date_beg,date_end,data,wd,shift,freq):
    """ The function take in argument :
    - wd : time window in days (int)
    - shift: time shifting for overlapping in days (int)
    """

    N = wd*24 # Number of samples
    
    wd = dt.timedelta(hours=N-1) # Remove the last hours
    shift = dt.timedelta(days=shift)

    freq_tab = [] 

    date = date_beg
    
    while date < date_end:

        date1 = date
        date2 = date1 + wd
        
        if len(data.loc[date1:date2].index) == N: # Ensure no lacking data
            fhobo, fera = mcr_fft(date1,date2,data)

            freq_tab.append([2/N*np.abs(fera[freq]),2/N*np.abs(fhobo[freq])])

        date = date + shift
            
    return np.array(freq_tab)


# Usage exemple

## The 0 frequency is the mean! But divide by 2.
freq = 0 
wd = 5  
shift = 3

freq_on = mcr_fft2(dt.datetime(2023,5,1,0),dt.datetime(2023,9,30,0),data,wd,shift,freq)
freq_off = mcr_fft2(dt.datetime(2023,1,1,0),dt.datetime(2023,5,1,0),data,wd,shift,freq)

sns.regplot(x=freq_on[:,0]/2,y=freq_on[:,1]/2,color='tab:green',label='Leaf on')
sns.regplot(x=freq_off[:,0]/2,y=freq_off[:,1]/2,color='tab:brown',label='Leaf off')
plt.xlim((0,25))
plt.xlabel('ERA temp.')
plt.ylim((0,25))
plt.ylabel('Hobo temp.')
plt.title('Mean temperature')
plt.show()

## The 5 frequency is the period 24:

freq = 5 # N=5*wd; freq = N/24
print('Check:',1/rfftfreq(N)[5])

freq_on = mcr_fft2(dt.datetime(2023,5,1,0),dt.datetime(2023,9,30,0),data,wd,shift,freq)
freq_off = mcr_fft2(dt.datetime(2023,1,1,0),dt.datetime(2023,5,1,0),data,wd,shift,freq)


sns.regplot(x=freq_on[:,0],y=freq_on[:,1],color='tab:green',label='Leaf on')
sns.regplot(x=freq_off[:,0],y=freq_off[:,1],color='tab:brown',label='Leaf off')
plt.xlim((0,7))
plt.xlabel('ERA temp.')
plt.ylim((0,7))
plt.ylabel('Hobo temp.')
plt.title('Frequency 24h')
plt.show()

# This is the second function wich return variance over a period or energy dissipation

def mcr_fft3(date_beg,date_end,data,wd,shift):
    """ The function take in argument :
    - wd : time window in days (int)
    - shift: time shifting for overlapping in days (int)
    """

    N = wd*24 # Number of samples
    
    wd = dt.timedelta(hours=N-1) # Remove the last hours
    shift = dt.timedelta(days=shift)

    energy_tab = [] 

    date = date_beg
    
    while date < date_end:

        date1 = date
        date2 = date1 + wd
        
        if len(data.loc[date1:date2].index) == N: # Ensure no lacking data
            fhobo, fera = mcr_fft(date1,date2,data)

            energy_tab.append([2/N*np.linalg.norm(fera[1:]),2/N*np.linalg.norm(fhobo[1:])])

        date = date + shift
            
    return np.array(energy_tab)


energy_on = mcr_fft3(dt.datetime(2023,5,1,0),dt.datetime(2023,9,30,0),data,wd,shift)
energy_off = mcr_fft3(dt.datetime(2023,1,1,0),dt.datetime(2023,5,1,0),data,wd,shift)

sns.regplot(x=energy_on[:,0],y=energy_on[:,1],color='tab:green',label='Leaf on')
sns.regplot(x=energy_off[:,0],y=energy_off[:,1],color='tab:brown',label='Leaf off')
plt.xlim((0,8))
plt.xlabel('ERA')
plt.ylim((0,8))
plt.ylabel('Hobo')
plt.title('Energy')
plt.show()
