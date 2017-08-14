pipeline {
	environment {
		def antVersion = 'Ant1.10.1'
	}

	agent any
	stages {
		stage('Initialize') {
			steps {
				withEnv( ["ANT_HOME=${tool antVersion}"] ) {
					echo 'ANT_HOME = ' + ANT_HOME
				}
				if (isUnix()) {
					echo 'Unix is not supported at this time'
				} else {
					bat(/"${ANT_HOME}\bin\ant.bat" -version/)
				}				
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
