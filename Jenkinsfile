pipeline {
  agent any
  stages {
    stage('git checkout') {
      steps {
        git(url: 'https://github.com/t-torii/terraform-vmware-createvm', branch: 'master')
      }
    }
  }
}