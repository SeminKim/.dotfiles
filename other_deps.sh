ln -fs /usr/share/zoneinfo/Asia/Seoul /etc/localtime && apt-get install tzdata
apt-get install -y wget zsh vim tmux curl git htop libgl1 libglib2.0-0 rsync language-pack-en sshfs pip file
pip install uv
uv pip install --system gpustat opencv-python matplotlib einops scikit-image scikit-learn jupyter jupyterlab ipdb easydict seaborn tensorboard timm wandb omegaconf jedi==0.18.2
git config --global user.name seminkim
git config --global user.email seminkim@kaist.ac.kr
git config --global core.autocrlf input
