FROM ipython/ipython

RUN mkdir /d

WORKDIR /d

ENV P_HOME /d/program

RUN apt-get update && apt-get install -y curl git wget vim cmake gcc g++ gfortran xpdf libzmq3-dev libbz2-dev libgdbm-dev liblzma-dev libreadline-dev libsqlite3-dev libssl-dev tcl-dev tk-dev dpkg-dev 

RUN  mkdir /d/download && mkdir /d/git && mkdir $P_HOME


#erlang
RUN cd download && wget http://www.erlang.org/download/otp_src_17.3.tar.gz && tar -xvf otp_src_17.3.tar.gz  && cd otp_src_17.3 && ./configure && make && make install && cd -

RUN cd git && git clone http://github.com/zeromq/erlzmq2.git && cd erlzmq2 && make && make test && make docs

ENV ERL_LIBS /d/git/erlzmq2
ENV PATH $PATH:$ERL_LIBS

RUN cd git && git clone http://github.com/hhland/ierlang.git
                                    

EXPOSE 8888

RUN cd git/ierlang && mv src/start-ierl-notebook.sh src/start-ierl-notebook.sh.bak

ADD add/start-ierl-notebook.sh /d/git/ierlang/src/

RUN chmod +x git/ierlang/src/start-ierl-notebook.sh

CMD git/ierlang/ierlang-notebook.sh
