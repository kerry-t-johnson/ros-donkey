FROM ros:foxy-ros-base-focal

# Prerequisites
RUN apt-get update                          &&  \
    apt-get install --yes   python3-pip

# Set our working directory
WORKDIR /usr/src/app

# Copy requirements.txt first for better cache on later pushes
COPY requirements.txt requirements.txt

# pip install python deps from requirements.txt on the resin.io build server
RUN pip3 install -r requirements.txt

# This will copy all files in our root to the working  directory in the container
COPY . ./

# Enable udevd so that plugged dynamic hardware devices show up in our container.
ENV UDEV=1

# main.py will run when container starts up on the device
CMD ["python3","-u","src/main.py"]