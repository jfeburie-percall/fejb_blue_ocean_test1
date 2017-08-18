pipeline {
	environment {
		def antVersion = 'Ant1.9.9'
		def HipChatRoom = 'Percall Jenkins Test'
		def EmailProjectRecipientList = 'jfeburie@percallgroup.com'
		def SubProjectName = 'fejb_blue_ocean_test2'
		def SubProjectGitUrl = 'git@github.com:jfeburie-percall/fejb_blue_ocean_test2.git'
	}

	agent any
	stages {
		stage('Initialize') {
			steps {
				bitbucketStatusNotify(buildState: 'INPROGRESS')
				echo 'Notifying Starting to Developers'
				notifyBuild('STARTED', true, true, false, 'Jenkins Build is Starting')
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
		stage('Collect Dependant Repos') {
			steps {
				echo 'SubProjectBranchName = ' + SubProjectBranch(BRANCH_NAME)
				dir ('dependencies/' + SubProjectName) {
					deletedir()
				}
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
		changed {
			// Only run if the current Pipeline run has a different status from the previously completed Pipeline.
			echo 'Notifying Back to normal to Developers'
			notifyBuild('SUCCESSFUL', false, false, true, 'Jenkins Build is back to normal')
		}
		failure {
			// Only run if the current Pipeline has a "failed" status, typically denoted in the web UI with a red indication.
			echo 'Notifying Failure to Developers'
			notifyBuild('FAILED', true, true, true, 'Build Failed in Jenkins')
		}
		success {
			// Only run if the current Pipeline has a "success" status, typically denoted in the web UI with a blue or green indication.
			echo 'Build Sucessfull, Archiving Artifacts to Jenkins'
			archiveArtifacts artifacts: 'build/*.zip'
			echo 'Notifying Success to Developers'
			notifyBuild('SUCCESSFUL', true, true, false, 'Jenkins Build is Successfull')
		}
//		unstable {
			// Only run if the current Pipeline has an "unstable" status, usually caused by test failures, code violations, etc. Typically denoted in the web UI with a yellow indication.
//		}
//		aborted {
			// Only run if the current Pipeline has an "aborted" status, usually due to the Pipeline being manually aborted. Typically denoted in the web UI with a gray indication
//		}
	}

}

def SubProjectBranch(String branchName) {
	def BranchToSubProject = [
		[branch: 'master'   , subPbranch: 'master'],
		[branch: 'develop'  , subPbranch: 'dev']
	]
	BranchToSubProject.find { it['branch'] ==  branchName }?.get("subPbranch")
}

def notifyBuild(String buildStatus = 'STARTED', NotifyBitbucket , NotifyHipChat , NotifyEmail , String EmailSubjectStart = 'Build Failed in Jenkins') {
	// build status of null means successful
	buildStatus       = buildStatus ?: 'SUCCESSFUL'
	NotifyBitbucket   = NotifyBitbucket ?: false
	NotifyHipChat     = NotifyHipChat ?: false
	NotifyEmail       = NotifyEmail ?: false
	EmailSubjectStart = EmailSubjectStart ?: 'Build Failed in Jenkins'
	echo 'buildStatus       = ' + buildStatus
	echo 'NotifyBitbucket   = ' + NotifyBitbucket
	echo 'NotifyHipChat     = ' + NotifyHipChat
	echo 'NotifyEmail       = ' + NotifyEmail
	echo 'EmailSubjectStart = ' + EmailSubjectStart
	
	// Default values
	def colorName = 'RED'
	def hipchatmessage = "${env.JOB_NAME} ${env.BUILD_NUMBER} ${buildStatus} " + '($HIPCHAT_CHANGES_OR_CAUSE)' + """ (<a href="${env.BUILD_URL}">View build</a>)"""
	def hipchatsound = false
	def subject = "${EmailSubjectStart}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'"
	def summary = "${subject} (${env.BUILD_URL})"
	def details = """<p>${buildStatus}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
	<p>Check console output at "<a href="${env.RUN_DISPLAY_URL}">${env.JOB_NAME} [${env.BUILD_NUMBER}] Console</a>"</p>
	<p>View Changes at "<a href="${env.RUN_CHANGES_DISPLAY_URL}">${env.JOB_NAME} [${env.BUILD_NUMBER}] Changes</a>"</p>
	<p>Link to the Job Homepage at "<a href="${env.JOB_DISPLAY_URL}">${env.JOB_NAME} Homepage</a>"</p>"""
	
	// Override default values based on build status
	if (buildStatus == 'STARTED') {
	color = 'YELLOW'
	hipchatmessage = "${env.JOB_NAME} ${env.BUILD_NUMBER} ${buildStatus} " + '($HIPCHAT_CHANGES_OR_CAUSE)' + """ (<a href="${env.BUILD_URL}">View build</a>)"""
	} else if (buildStatus == 'SUCCESSFUL') {
	color = 'GREEN'
	hipchatmessage = "${env.JOB_NAME} ${env.$BUILD_NUMBER} ${buildStatus} " + 'after $BUILD_DURATION ($HIPCHAT_CHANGES_OR_CAUSE)' + """ (<a href="${env.BUILD_URL}">View build</a>)"""
	} else {
	color = 'RED'
	hipchatsound = true
	}
	
	// Send notifications
	
	if (NotifyHipChat == true) {
		echo 'Notifying Build Status to HipChat Room'
		hipchatSend (color: color, notify: hipchatsound, message: hipchatmessage, room: HipChatRoom)
	}

	if (NotifyBitbucket == true) {
		echo 'Notifying Build Status to Bitbucket'
		bitbucketStatusNotify(buildState: buildStatus)
	}
	
	if (NotifyEmail == true) {
		emailext (
			subject: subject,
			body: details,
			to: EmailProjectRecipientList,
			recipientProviders: [[$class: 'DevelopersRecipientProvider']]
		)
	}
}

