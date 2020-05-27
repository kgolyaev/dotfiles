# -----------------------------------------------------------------------------
# 
# Random pieces of python code that I found to be reinventing
#
# -----------------------------------------------------------------------------
import os
import pandas as pd
from datetime import timedelta

###############################################################################
## Get recursive list of files from subdirectories
list_of_files = [os.path.join(x[0], y) for x in os.walk(DIRNAME) for y in x[2]]
# optionally only include some files
list_of_files_with_condition = [
    os.path.join(x[0], y) for x in os.walk(DIRNAME) for y in x[2] 
                          if y.endswith('csv')]

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

