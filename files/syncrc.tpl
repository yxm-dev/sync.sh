#! /bin/bash

# Declarations
    declare -A SYNC_blocks
    declare -A SYNC_source
    declare -A SYNC_target
    declare -A SYNC_alias
    declare -A SYNC_max

# Complete the associative 1-dimensional array of blocks.
# The block files must exist by default.
    SYNC_blocks["files"]="files"

# Example
## SYNC_blocks["block_1"]="block_1"
## SYNC_blocks["block_2"]="block_2"
## ...
   
# In the block "files", add source/target files and aliases in the
# form of 2-dimensional associative arrays.
# OBS: Be sure to have aliases which are unique in the document

# Example: for two pairs of files
## SYNC_source["files",0]="source_file_0"
## SYNC_target["files",0]="target_file_0"
## SYNC_alias["files",0]="alias_files_0"
## SYNC_source["files",1]="source_file_1"
## SYNC_target["files",1]="target_file_1"
## SYNC_alias["files",1]="alias_files_1"

# Do the same for each other block defined in SYNC_blocks, but now 
# adding pairs of directories instead of files.

# Example
## SYNC_source["block_1",0]="source_dir_1_0"
## SYNC_target["block_1",0]="target_dir_1_0"
## SYNC_alias["block_1",0]="alias_block_1_0"
## ...
## SYNC_source["block_2",0]="source_dir_2_0"
## SYNC_target["block_2",0]="target_dir_2_0"
## SYNC_alias["block_2",0]="alias_block_2_0"
## ...

# For each block (including the block files) add the total number of
# file/dir pairs, minus one.
# OBS: this is precisely the maximal index of SYNC_alias["block",*]

# Example: in the case of two pairs of files
## SYNC_max["files"]=1
    
