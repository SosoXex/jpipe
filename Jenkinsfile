pipeline{
    agent any
    stages{
        stage('build app'){
            steps{
                    sh script:'ssh -tt root@172.31.17.31 \'rm -rf /tmp/build \
                    && mkdir -p /tmp/build && cd /tmp && export dhpass=\'1234Jenkins\' \
                    &&  export dhhost=\'172.31.23.200:8123\'&& export dhuser=\'jenkins\' \
                    && git clone https://github.com/SosoXex/jpipe.git build \
                    && cd build && docker build -t appbuilder:v4.0 . \
                    && docker run --rm -v /var/run/docker.sock:/var/run/docker.sock appbuilder:v4.0 /bin/bash -c \
                    "git clone https://github.com/koddas/war-web-project.git\
                    ; mvn package -f /tmp/build/war-web-project;docker build -t sappj:v1.0 .\
                    ;docker login $dhhost -u $dhuser -p $dhpass\
                    ;docker tag sappj:v1.0 $dhhost/sappj:v1.0\
                    ;docker push $dhhost/sappj:v1.0"\''
            }
        }
        stage('deploy app'){
            steps{
                    sh script:'ssh -tt root@172.31.23.172 \'rm -rf /tmp/srv \
                    && mkdir -p /tmp/srv \
                    && cd /tmp/srv \
                    && docker rm $(docker ps -aq) -f \
                    && docker rmi -f $(docker images -q) \
                    && export dhpass=\'1234Jenkins\' \
                    &&  export dhhost=\'172.31.23.200:8123\' \
                    && export dhuser=\'jenkins\' \
                    && docker login $dhhost -u $dhuser -p $dhpass \
                    && docker pull $dhhost/sappj:v1.0 \
                    && docker run --name sapps -d -p 8080:8080 $dhhost/sappj:v1.0\''
            }
        }
    }
}
