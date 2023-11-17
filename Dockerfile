FROM ubuntu:20.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
git \
python3-pip \
ffmpeg \
libsm6 \
libxext6 \
curl \
unzip \
wget \
&& rm -rf /var/lib/apt/lists/*

# installing gdown for downloading files from google drive
RUN pip install gdown --upgrade

# cloning repository
RUN git clone https://github.com/stefanopini/simple-HRNet.git
WORKDIR /simple-HRNet
RUN pip install -r requirements.txt
# RUN apt update && ap install -y vlc

# adding yolov3
RUN git submodule update --init --recursive && \ 
cd /simple-HRNet/models_/detectors/yolo && \
pip install -q -r requirements.txt

# adding yolov3 weights
RUN cd /simple-HRNet/models_/detectors/yolo/weights && \
wget -c https://pjreddie.com/media/files/yolov3.weights && \
wget -c https://pjreddie.com/media/files/yolov3-tiny.weights && \
wget -c https://pjreddie.com/media/files/darknet53.conv.74

# downloading weights for hrnet pre-trained weights
RUN cd /simple-HRNet && \
pip install --upgrade --no-cache-dir gdown && \
mkdir weights && cd weights && \
gdown 1UoJhTtjHNByZSm96W3yFTfU5upJnsKiS && \
gdown 1zYC7go9EV0XaSlSBjMaiyE_4TcHc_S38 && \
gdown 1_wn2ifmoQprBrFvUCDedjPON4Y6jsN-v

# downloading testing video
RUN cd /simple-HRNet && \
wget https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4

# making output dir for csv 
RUN mkdir output

# building nms module for running the training script
# RUN cd misc/nms; python3 setup_linux.py build_ext --inplace

# adding the ./misc/nms directory in the PYTHONPATH variable
# RUN export PYTHONPATH="simple-HRNet/misc/nms:$PYTHONPATH"

# RUN cd /simple-HRNet && \
# pip install json_tricks && \
# pip install pycocotools