FROM tomcat:jre8

# Grab RAMADDA
RUN curl -SL \
  http://sourceforge.net/projects/ramadda/files/ramadda1.7/repository.war \
  -o webapps/repository.war

ENV DATA_DIR /data/repository

RUN mkdir -p $DATA_DIR

VOLUME $DATA_DIR

ENV JAVA_OPTS -d64 -Xmx4048m -Xms512m \
  -Dorg.apache.catalina.security.SecurityListener.UMASK=0007 -server \
  -Dramadda_home=$DATA_DIR -Dfile.encoding=utf-8

ENV CATALINA_OPTS -Dorg.apache.jasper.runtime.BodyContentImpl.LIMIT_BUFFER=true

# Create tomcat user
RUN groupadd -r tomcat && \
	useradd -g tomcat -d ${CATALINA_HOME} -s /sbin/nologin  -c \
  "Tomcat user" tomcat && chown -R tomcat:tomcat ${CATALINA_HOME}

WORKDIR $DATA_DIR

RUN chown -R tomcat /data/repository

USER tomcat

CMD ["catalina.sh", "run"]
