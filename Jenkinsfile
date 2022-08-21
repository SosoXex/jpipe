pipeline{
    agent none
    stages{
        stage('build app'){
        agent any
            steps{
            sh 'rm -rf build && mkdir -p build'
            sh 'git clone https://github.com/SosoXex/jpipe.git build'
            sh 'cd build && pwd && cp df/Dockerfile ../ && cat df/Dockerfile && docker build -t appbuilder:v6.0 .'
            }
        }
        stage('run app'){
        agent{
                docker{
                    args '--rm -v /var/run/docker.sock:/var/run/docker.sock -u root'
                    image 'appbuilder:v6.0'
                }
            }
            steps{
                    sh 'export dhhost=\'172.31.23.200:8123\'&& export dhuser=\'jenkins\''
                    sh 'rm -rf war-web-project df jpipe&& git clone https://github.com/koddas/war-web-project.git'
                    sh 'git clone https://github.com/SosoXex/jpipe.git && cp jpipe/df/Dockerfile $PWD/Dockerfile'
                    sh 'pwd && ls -la'
                    sh 'mvn package -f $PWD/war-web-project'
                    sh 'pwd && ls -la && cat Dockerfile && docker build -t sappj:v1.0 .'
                    sh 'docker login $dhhost -u $dhuser -p $dhpass'
                    sh 'docker tag sappj:v1.0 $dhhost/sappj:v1.0'
                    sh 'docker push $dhhost/sappj:v1.0"'
            }
        }
        stage('deploy app'){
        agent any
            steps{
                    sh script:'ssh -tt root@172.31.23.172 \'rm -rf /tmp/srv \
                    && mkdir -p /tmp/srv && cd /tmp/srv \
                    && docker rm $(docker ps -aq) -f && docker rmi -f $(docker images -q) \
                    && sh export dhhost=\'172.31.23.200:8123\'&& export dhuser=\'jenkins\'\
                    && docker login $dhhost -u $dhuser -p $dhpass \
                    && docker pull $dhhost/sappj:v1.0 \
                    && docker run --name sapps -d -p 8080:8080 $dhhost/sappj:v1.0\''
            }
        }
    }
}
