FROM ubuntu
RUN apt update
RUN apt --yes install python3-pip
RUN apt --yes install openjdk-17-jre
ADD spark-requirements.txt /
ADD datagen-requirements.txt /
RUN pip3 install -r /spark-requirements.txt
RUN pip3 install -r /datagen-requirements.txt