FROM brettdah/centos6-novsyscall:latest

RUN yum makecache fast \
	&& yum install -y upstart \
	&& yum clean all
	
CMD ["/sbin/init"]
#CMD ["/bin/bash"]
