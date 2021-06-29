FROM python:3.7

# Creating a virtual environment for cutadapt
ENV VIRTUAL_ENV=/opt/multiqc-env
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Updating
RUN pip install --no-cache-dir -U pip setuptools wheel

# Installing deepTools
RUN pip install --no-cache-dir 'multiqc==1.9'

# Adding the wrapper script
COPY execute_multiqc.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/execute_multiqc.sh

# Adding the default plot configuration yaml
COPY multiqc_config_plots.yaml /opt/multiqc-env/
RUN chmod 644 /opt/multiqc-env/multiqc_config_plots.yaml

# Creating the working directory
RUN mkdir -p /workdir
WORKDIR /workdir
