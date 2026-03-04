pipeline {
    agent any

    stages {
      stage("Show Details") {
        steps {
          script {
            echo env.BRANCH_NAME
            sh 'pwd'
              sh 'java -version'
              sh '''
                mvn --version
              '''
              sh '''
                  which docker
              '''
          }
        }
      }
    }
}
