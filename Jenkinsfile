pipeline {
    agent any

    stages {
      stage("Show Details") {
        steps {
          script {
            echo env.BRANCH_NAME
            sh 'pwd'
            sh 'echo $PATH'
              sh 'java -version'
              sh '''
                mvn --version
              '''
              sh '''
                  which docker
              '''
              sh '''
                cd $HOME/workspace/myProjects/java/springboot/spring-boot-ci-jenkins
                echo $DOCKER_USERNAME
              '''
          }
        }
      }
    }
}
