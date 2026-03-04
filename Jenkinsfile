def VERSION = ''
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

            env.VERSION = sh(
              script: 'mvn -q -Dexec.executable=echo -Dexec.args=\'${project.version}\' --non-recursive exec:exec',
              returnStdout: true
            ).trim()

             echo "VERSION=${env.VERSION}"
          }
        }
      }

      stage("Build image") {
        steps {
          script {
            sh """
                docker build --build-arg VERSION=${env.VERSION} -t spring-boot-ci-jenkins .
            """
          }
        }
      }

      stage("Tag image") {
        steps {
          script {
            sh 'docker tag spring-boot-ci-jenkins shreyasvh/spring-boot-ci-jenkins:${env.VERSION}'
            sh 'docker tag spring-boot-ci-jenkins shreyasvh/spring-boot-ci-jenkins:latest'

            sh 'docker images'
          }
        }
      }
    }
}
