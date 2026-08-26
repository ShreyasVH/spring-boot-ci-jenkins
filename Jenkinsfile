def VERSION = ''
def IMAGE_NAME = 'spring-boot-ci-jenkins'
pipeline {
    agent any

    stages {
      stage("Show Details") {
        steps {
          script {
            echo env.BRANCH_NAME

            env.VERSION = sh(
              script: 'mvn -q -Dexec.executable=echo -Dexec.args=\'${project.version}\' --non-recursive exec:exec',
              returnStdout: true
            ).trim()

             echo "VERSION=${env.VERSION}"
          }
        }
      }

      stage("Setup Docker Buildx") {
          when {
              expression {
                  return env.BRANCH_NAME == 'main' || env.BRANCH_NAME == '2-update-the-ci-steps-to-push-both-arm-and-amd-images'
              }
          }
          steps {
              sh '''
                  docker buildx create --use --name multiarch-builder 2>/dev/null || docker buildx use multiarch-builder

                  docker buildx inspect --bootstrap
              '''
          }
      }

      stage("Docker login") {
        when {
          expression {
            return env.BRANCH_NAME == 'main' || env.BRANCH_NAME == '2-update-the-ci-steps-to-push-both-arm-and-amd-images'
          }
        }
        steps {
          script {
            withCredentials([usernamePassword(
              credentialsId: 'docker-creds',
              usernameVariable: 'DOCKER_USERNAME',
              passwordVariable: 'DOCKER_PASSWORD'
            )]) {
              sh '''
                echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
              '''
            }
          }
        }
      }

      stage("Build and Push Multi-Arch Image") {
        when {
          expression {
              return env.BRANCH_NAME == 'main' || env.BRANCH_NAME == '2-update-the-ci-steps-to-push-both-arm-and-amd-images'
            }
          }
          steps {
            sh '''
               #docker buildx build --platform linux/amd64,linux/arm64 --build-arg VERSION="${VERSION}" -t "${IMAGE_NAME}:${VERSION}" -t "${IMAGE_NAME}:latest" --push .
               docker buildx build --platform linux/amd64,linux/arm64 --build-arg VERSION="${VERSION}" -t "${IMAGE_NAME}:test" --push .
            '''
          }
        }
      }
}
