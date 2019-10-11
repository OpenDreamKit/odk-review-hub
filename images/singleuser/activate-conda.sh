# enable conda and activate the notebook environment
CONDA_PROFILE="${CONDA_DIR}/etc/profile.d/conda.sh"
test -f $CONDA_PROFILE && . $CONDA_PROFILE
conda activate notebook
