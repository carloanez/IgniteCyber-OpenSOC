FROM jupyter/minimal-notebook:latest

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl jq \
    && rm -rf /var/lib/apt/lists/*

USER jovyan

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Start JupyterLab
CMD ["bash", "-lc", "jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --ServerApp.token=${JUPYTER_TOKEN} --ServerApp.allow_origin='*'"]
