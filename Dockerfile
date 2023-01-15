#+-+-+-+-+-+-+-+
#|c|o|m|p|i|l|e|
#+-+-+-+-+-+-+-+
FROM python:3.10-slim-buster AS compile-image
LABEL maintainer="kirill.podkov@outlook.com"

# Install dependencies
RUN apt -y update
RUN apt -y upgrade
RUN apt -y install gcc g++

# Install Python dependencies
RUN mkdir /install
WORKDIR /install
COPY requirements.txt requirements.txt
RUN pip install --prefix="/install" -r requirements.txt

#+-+-+-+-+-+-+-+
#|r|u|n|t|i|m|e|
#+-+-+-+-+-+-+-+
FROM python:3.10-slim-buster AS runtime-image

COPY --from=compile-image /install /usr/local

COPY scripts /app
WORKDIR /app

CMD ["python", "consumer.py"]

