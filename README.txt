Overview
This script automates the calculation of Root Mean Square Fluctuations (RMSF) for the C-alpha (CA) atoms of specified systems using VMD (Visual Molecular Dynamics). It is designed for systems with molecular dynamics trajectories and structures in GRO and XTC formats, respectively.

Features
Batch Processing: Automatically handles multiple systems.
Customizable Parameters: Easily modify systems, directories, file patterns, and skip frames.
Robust Error Handling: Identifies missing files and skips invalid systems.
Efficient Output Management: Generates separate output files for each system with RMSF data.
VMD TCL Integration: Creates and executes custom TCL scripts for each system.
Requirements
Software
VMD: Version 1.9 or later is recommended.
File Formats
Structure File: GRO format (e.g., Soluteonly.gro).
Trajectory File: XTC format with a specific naming pattern (e.g., prod-*-400ns-nopbc-notwat.xtc).
Usage Instructions
1. Prepare the Input Files
Ensure each system directory contains:

A GRO file (e.g., Soluteonly.gro).
A trajectory file matching the specified pattern (prod-*-400ns-nopbc-notwat.xtc).
2. Configure the Script
Edit the following parameters in the script as required:

SYSTEMS: List of systems to process (e.g., WT, A97V, etc.).
BASE_DIR: Base directory containing the system folders.
STRUCTURE_FILE: Name of the GRO structure file.
TRAJECTORY_FILE_PATTERN: Pattern for identifying the trajectory file.
SKIP_FRAMES: Number of frames to skip during analysis.
3. Run the Script
Execute the script in the terminal:

bash
Copy code
bash rmsf_calculation.sh
4. Output Files
Each system will produce:

RMSF Data File: <System>-rmsf-CA.txt containing residue indices and corresponding RMSF values.
