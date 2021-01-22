# -----------------------------------------------------------------------------
# 
# Random pieces of python code that I found to be reinventing
#
# -----------------------------------------------------------------------------
import os
import pandas as pd
import numpy as np
from datetime import timedelta

###############################################################################
## Get recursive list of files from subdirectories
list_of_files = [os.path.join(x[0], y) for x in os.walk(DIRNAME) for y in x[2]]
# optionally only include some files
list_of_files_with_condition = [
    os.path.join(x[0], y) for x in os.walk(DIRNAME) for y in x[2] 
                          if y.endswith('csv')]

###############################################################################                          
## Get absolute path to directory in which current file is located
DIRPATH = os.path.abspath(os.path.dirname(__file__))
## if you need to navigate away from that directory, e.g. one dir above
## this is how
REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
###############################################################################                          
## Fast rounding of date to week start, 
## with custom day-of-week as week_start_day
POSSIBLE_WEEK_STARTS =  {
    'Monday': 0, 
    'Tuesday': 1, 
    'Wednesday': 2, 
    'Thursday': 3, 
    'Friday' : 4, 
    'Saturday': 5,
    'Sunday': 6, 
}
def round_date_to_week_start(
        df, 
        time_colname, 
        new_time_colname,
        week_start_day,
    ):
    """
    Given dataframe `df` with column `time_colname` that has datetime values,
    and given that we want weeks to start with `week_start_day` (one of seven
    possibilities in `POSSIBLE_WEEK_STARTS`), create `new_time_colname` with
    date values rounded to first date of week.
    
    This solution avoids using pd.DateOffset() which is slow because it is not
    vectorized, unlike this solution :)
    """
    result = df.copy()
    result[new_time_colname] = (
        (result[time_colname] - timedelta(POSSIBLE_WEEK_STARTS[week_start_day]))
        .dt.to_period('W')
        .dt.start_time + timedelta(POSSIBLE_WEEK_STARTS[week_start_day])
    )
    return result
###############################################################################                          
## Replacing NaN values in pandas columns with empty lists
## Useful when column contains lists, e.g. as a result of .str.split() call
df = pd.DataFrame({'x': ['a, b', 'alpha', np.nan, 'i, j, k', np.nan, ]})
df['y'] = df['x'].str.split(', ')
# at this point, here is the contents of df:
#          x          y
# 0     a, b     [a, b]
# 1    alpha    [alpha]
# 2      NaN        NaN
# 3  i, j, k  [i, j, k]
# 4      NaN        NaN
df['z'] = df['y'].copy()
# method 1 - work in new-ish pandas
df.loc[df['y'].isna(), 'y'] = [[]] # note: [] instead of [[]] won't work
# method 2: more robust, but slower
df['z'] = df['z'].apply(lambda x: x if isinstance(x, list) else [])
# once values in every row is a list, can, e.g., add two such columns safely
###############################################################################                          
## Handling None values in pandas 
## Useful when splitting column into multiple via .str.split(expand=True)
df = pd.DataFrame({'x': ['a, b', 'alpha', np.nan, 'i, j, k', np.nan, ]})
df_split = df['x'].str.split(', ', expand=True)
# this is what df_split contains at this point:
#        0     1     2
# 0      a     b  None
# 1  alpha  None  None
# 2    NaN   NaN   NaN
# 3      i     j     k
# 4    NaN   NaN   NaN

# newer pandas versions can handle NaN and None together
df_split.fillna('') # fills both NaN and None with empty strings
# but if you need to handle None separately, here is a useful trick:
df_split[df_split.applymap(lambda x: x is None)] = 'empty'
# now all NaNs are preserved, but None's are handled:
#        0      1      2
# 0      a      b  empty
# 1  alpha  empty  empty
# 2    NaN    NaN    NaN
# 3      i      j      k
# 4    NaN    NaN    NaN
###############################################################################                          

