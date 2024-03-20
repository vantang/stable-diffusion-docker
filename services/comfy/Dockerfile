FROM pytorch/pytorch:2.2.0-cuda11.8-cudnn8-runtime

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

RUN apt-get update && apt-get install -y git build-essential software-properties-common fonts-dejavu-core libgl1 && apt-get clean

RUN add-apt-repository ppa:ubuntuhandbook1/ffmpeg6 -y

RUN apt-get install -y ffmpeg

RUN conda config --add channels conda-forge

RUN conda install conda-forge::ffmpeg -y

ENV ROOT=/stable-diffusion
RUN --mount=type=cache,target=/root/.cache/pip \
  git clone https://github.com/comfyanonymous/ComfyUI.git ${ROOT} && \
  cd ${ROOT} && \
  git checkout master && \
  #git reset --hard 236bda26830d719843ba9b5703894297f67f6704 && \
  pip install -r requirements.txt &&

#I need these,you can comment it
RUN pip install onnx onnxruntime imageio-ffmpeg segment_anything pydantic omegaconf timm google-generativeai rembg insightface==0.7.3 facexlib numexpr
RUN onnxruntime-gpu

WORKDIR ${ROOT}
COPY . /docker/
RUN chmod u+x /docker/entrypoint.sh && cp /docker/extra_model_paths.yaml ${ROOT}

ENV NVIDIA_VISIBLE_DEVICES=all PYTHONPATH="${PYTHONPATH}:${PWD}" CLI_ARGS=""
EXPOSE 7860
ENTRYPOINT ["/docker/entrypoint.sh"]
CMD python -u main.py --listen --port 7860 ${CLI_ARGS}
