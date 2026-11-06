# Install-only image for the embedding worker: public packages and public model weights. No keys, no data, no project code.
# Versions match PIP_COMMON and the cu128 torch line in controller.py, so vectors match the rest of the run.
FROM python:3.11-slim
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends gcc g++ libc6-dev && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir --root-user-action=ignore --extra-index-url https://download.pytorch.org/whl/cu128 \
    torch==2.7.1+cu128 torchvision==0.22.1+cu128 open_clip_torch==3.3.0 timm==1.0.29 ftfy regex requests pillow numpy
ENV HF_HOME=/opt/hf
RUN python -c "import open_clip; open_clip.create_model_and_transforms('ViT-gopt-16-SigLIP2-384', pretrained='webli')"
ENV HF_HUB_OFFLINE=1
RUN touch /opt/preinstalled
