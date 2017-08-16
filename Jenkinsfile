pipeline {
	environment {
		def antVersion = 'Ant1.9.9'
	}

	agent any
	stages {
		stage('Initialize') {
			steps {
				bitbucketStatusNotify(buildState: 'INPROGRESS')
				notifyStarted()
				withEnv( ["ANT_HOME=${tool antVersion}"] ) {
					echo 'ANT_HOME = ' + ANT_HOME
					bat(/"$ANT_HOME\bin\ant.bat" -version/)
				}
				echo 'env.BRANCH_NAME  = ' + BRANCH_NAME
				echo 'env.BUILD_NUMBER = ' + BUILD_NUMBER
				echo 'env.JOB_NAME     = ' + JOB_NAME
				echo 'env.JENKINS_HOME = ' + JENKINS_HOME
				echo 'env.WORKSPACE    = ' + env.WORKSPACE
			}
		}
		stage('Build') {
			steps {
				echo 'Starting Build'
				withEnv( ["ANT_HOME=${tool antVersion}"] ) {
					bat(/"$ANT_HOME\bin\ant.bat" -file "$env.WORKSPACE\DELIVERY\ac4_acme\build.xml"  && exit %%ERRORLEVEL%%/)
				}
				echo 'Build Complete'
			}
		}
	}
	post {
//		always {
			// Run regardless of the completion status of the Pipeline run.
//		}
//		changed {
			// Only run if the current Pipeline run has a different status from the previously completed Pipeline.
//		}
		failure {
			// Only run if the current Pipeline has a "failed" status, typically denoted in the web UI with a red indication.
			echo 'Notifying Failure to Bitbucket'
			bitbucketStatusNotify(buildState: 'FAILED')
		}
		success {
			// Only run if the current Pipeline has a "success" status, typically denoted in the web UI with a blue or green indication.
			echo 'Build Sucessfull, Archiving Artifacts to Jenkins'
			archiveArtifacts artifacts: 'build/*.zip'
			echo 'Notifying Success to Bitbucket'
			bitbucketStatusNotify(buildState: 'SUCCESSFUL')
		}
//		unstable {
			// Only run if the current Pipeline has an "unstable" status, usually caused by test failures, code violations, etc. Typically denoted in the web UI with a yellow indication.
//		}
//		aborted {
			// Only run if the current Pipeline has an "aborted" status, usually due to the Pipeline being manually aborted. Typically denoted in the web UI with a gray indication
//		}
	}

}

def notifyStarted() {
	// send to email
	emailext ( 
		subject: "STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'", 
		body: """<p>STARTED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
		<p>Check console output at "<a href="${env.BUILD_URL}">${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>"</p>""",
		recipientProviders: [[$class: 'DevelopersRecipientProvider']]
	)
}

