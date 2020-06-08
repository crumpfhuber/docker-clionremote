FROM ubuntu:latest
MAINTAINER Clemens Rumpfhuber <mail@clemens-rumpfhuber.at>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y ssh build-essential gcc g++ gdb clang cmake rsync tar python
RUN apt-get clean -y

RUN adduser --disabled-password	clionremote

RUN mkdir /etc/ssh/keys/
RUN echo 'Protocol 2' >> /etc/ssh/sshd_config.d/remoteclion.conf
RUN echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config.d/remoteclion.conf
RUN echo 'AuthorizedKeysFile /etc/ssh/keys/%u' >> /etc/ssh/sshd_config.d/remoteclion.conf
RUN echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config.d/remoteclion.conf
RUN echo 'ChallengeResponseAuthentication no' >> /etc/ssh/sshd_config.d/remoteclion.conf
RUN echo 'Subsystem sftp /usr/lib/openssh/sftp-server' >> /etc/ssh/sshd_config.d/remoteclion.conf

COPY id_ed25519.pub /etc/ssh/keys/clionremote

RUN mkdir /run/sshd

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config.d/remoteclion.conf"]
