FROM ubuntu:17.10

MAINTAINER Simone Roberto Nunzi "simone.roberto.nunzi@gmail.com"

# Install required software
RUN apt-get update && apt-get install -y sudo git wget zip genisoimage bc squashfs-tools xorriso tar klibc-utils iproute2 dosfstools rsync unzip findutils iputils-ping grep

# Install required packages for kernel building
RUN apt-get install -y build-essential libncurses5-dev libssl-dev libelf-dev bison

# Download repository
RUN git clone https://github.com/stockmind/gpd-pocket-ubuntu-respin.git ./gpd-pocket-ubuntu-respin

# Download isorespin script
RUN wget -O gpd-pocket-ubuntu-respin/isorespin.sh "https://drive.google.com/uc?export=download&id=0B99O3A0dDe67S053UE8zN3NwM2c"

RUN mkdir /docker-input
RUN mkdir /docker-output

COPY ./docker-entrypoint.sh /
RUN chmod +x docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
