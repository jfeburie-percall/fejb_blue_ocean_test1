pipeline {
	environment {
		def antVersion = 'Ant1.10.1'
		ANT_HOME=${tool antVersion}
	}

	agent any
	stages {
		stage('Initialize') {
			steps {
				echo 'ANT_HOME = '
				echo ANT_HOME
			}
		}
		stage('Build') {
			steps {
				echo 'Starting Build'
				echo 'Build Complete'
			}
		}
	}
}
