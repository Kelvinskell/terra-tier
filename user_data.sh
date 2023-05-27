apt update
apt upgrade -y
apt install python3-venv
mkdir project-x && cd project-x
source venv/bin/activate
pip install Flask