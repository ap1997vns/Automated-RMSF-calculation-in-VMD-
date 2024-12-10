#!/bin/bash

# Generalized Automated RMSF calculations in VMD 
SYSTEMS=("WT" "A97V" "S171L" "T180I" "M188I")  # Modify this list for your systems
BASE_DIR="/home/user/WORK/DgoR"                # Base directory for systems (change it according to where you have placed the file)
STRUCTURE_FILE="Soluteonly.gro"                # Input structure file (GRO format)
TRAJECTORY_FILE_PATTERN="prod-*-400ns-nopbc-notwat.xtc" # Trajectory file pattern
SKIP_FRAMES=10                                 # Frames to skip in the trajectory
OUTPUT_SUFFIX="rmsf-CA.txt"                    # Output RMSF file suffix
TCL_SUFFIX="rmsf.tcl"                          # TCL script suffix


for mut in "${SYSTEMS[@]}"; do
  SYSTEM_DIR="$BASE_DIR/$mut"
  GRO_FILE="$SYSTEM_DIR/$STRUCTURE_FILE"
  TRAJECTORY_FILE=$(find "$SYSTEM_DIR" -name "$TRAJECTORY_FILE_PATTERN" -type f)

  
  if [[ ! -f "$GRO_FILE" || ! -f "$TRAJECTORY_FILE" ]]; then
    echo "Missing files for $mut. Ensure $STRUCTURE_FILE and trajectory match the pattern."
    continue
  fi

  TCL_SCRIPT="$SYSTEM_DIR/$mut-$TCL_SUFFIX"
  OUTPUT_FILE="$SYSTEM_DIR/$mut-$OUTPUT_SUFFIX"

  
  {
    echo "mol new $GRO_FILE type gro"
    echo "mol addfile $TRAJECTORY_FILE type xtc skip $SKIP_FRAMES waitfor all molid 0"
    echo ""
    echo "set outfile [open \"$OUTPUT_FILE\" w]"
    echo "set sel [atomselect top \"name CA\"]"
    echo "set ref [atomselect top \"name CA\" frame 0]"
    echo "set compare [atomselect top \"name CA\"]"
    echo "set num_steps [molinfo top get numframes]"
    echo "for {set frame 0} {\$frame < \$num_steps} {incr frame} {"
    echo "  set all [atomselect top \"noh\" frame \$frame]"
    echo "  \$compare frame \$frame"
    echo "  set trans_mat [measure fit \$compare \$ref]"
    echo "  \$all move \$trans_mat"
    echo "}"
    echo "set reslist [lsort -unique -integer [ \$sel get residue ]]"
    echo "foreach r \$reslist {"
    echo "  set sel1 [atomselect top \"residue \$r and name CA\"]"
    echo "  set rmsf [measure rmsf \$sel1]"
    echo "  set resid [ expr \$r + 0 ]"
    echo "  puts \$outfile \"\$resid \$rmsf\""
    echo "}"
    echo "close \$outfile"
    echo "exit"
  } > "$TCL_SCRIPT"

  
  vmd -dispdev text -eofexit -e "$TCL_SCRIPT"
done
