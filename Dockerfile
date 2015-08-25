# Metasploit
FROM ruby:2.1.7
MAINTAINER Mads Hvelplund <mhv@tmnet.dk>

ENV MSF_DATABASE_CONFIG /etc/metasploitdb.yml

# Get dependencies
RUN apt-get -qq update
RUN apt-get -y install nmap postgresql libpcap-dev

# Create DB & user
RUN /etc/init.d/postgresql start && su postgres -c "psql -c \"CREATE USER msf WITH PASSWORD 'msf';\"" && su postgres -c "createdb -O msf msf"

# Install metasploit
RUN git clone https://github.com/rapid7/metasploit-framework.git /opt/metasploit-framework
WORKDIR /opt/metasploit-framework
RUN gem install bundler
RUN bundle install
WORKDIR /

# Add DB configuration
ADD db.yml /etc/metasploitdb.yml

VOLUME /var/lib/postgresql

# Boot-up with msfconsole
CMD /etc/init.d/postgresql start && msfconsole