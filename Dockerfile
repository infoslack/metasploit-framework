FROM infoslack/docker-ruby:2.1.5

MAINTAINER Daniel Romero <infoslack@gmail.com>

RUN apt-get update && apt-get -y install \
        bison \
        libbison-dev \
        libpcap-dev \
        libpcap0.8 \
        libpcap0.8-dev \
        postgresql-client \
        bzip2 \
    && rm -rf /var/lib/apt/lists/*

ENV NMAP_VERSION 6.47

RUN wget http://nmap.org/dist/nmap-${NMAP_VERSION}.tar.bz2 \
        && bzip2 -cd nmap-${NMAP_VERSION}.tar.bz2 | tar xvf - \
        && cd nmap-${NMAP_VERSION} \
        && ./configure && make && make install \
        && cd \
        && rm -rf nmap-${NMAP_VERSION}

RUN git clone --depth=1 https://github.com/rapid7/metasploit-framework.git \
        && cd metasploit-framework \
        && bundle install


COPY . /metasploit-framework
WORKDIR /metasploit-framework

EXPOSE 4444
CMD ["./msfconsole"]
