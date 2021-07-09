#Don't change this line:
FROM 079623148045.dkr.ecr.ca-central-1.amazonaws.com/bb-prod/e26fd040-f33e-4ccd-acee-099aefd0be97:latest

#Add your commands below.
# Creating a virtual environment for cutadapt
ENV VIRTUAL_ENV=/opt/multiqc-env
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Updating
RUN pip install --no-cache-dir -U pip setuptools wheel

# Installing deepTools
RUN pip install --no-cache-dir 'multiqc==1.9'

# Adding the wrapper script
ADD https://github.com/johanna-sandoval/multiqc/blob/master/execute_multiqc.sh /usr/local/bin
RUN chmod 755 /usr/local/bin/execute_multiqc.sh

# Adding the default plot configuration yaml
ADD https://github.com/johanna-sandoval/multiqc/blob/master/multiqc_config_plots.yaml /opt/multiqc-env/
RUN chmod 644 /opt/multiqc-env/multiqc_config_plots.yaml

# Creating the working directory
RUN mkdir -p /workdir
WORKDIR /workdir
