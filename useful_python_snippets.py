# -----------------------------------------------------------------------------
# 
# Random pieces of python code that I found to be reinventing
#
# -----------------------------------------------------------------------------

###############################################################################
## Get recursive list of files from subdirectories
import os
list_of_files = [os.path.join(x[0], y) for x in os.walk(DIRNAME) for y in x[2]]
# optionally only include some files
list_of_files_with_condition = [
    os.path.join(x[0], y) for x in os.walk(DIRNAME) for y in x[2] 
                          if y.endswith('csv')]
###############################################################################                          

