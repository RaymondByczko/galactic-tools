#!/usr/bin/python3.2
#
# @company self
# @author Raymond Byczko
# @start_date 2013-06-16 June 16
# @purpose To use the abilities of FtpDeploy in pushing code up to
# a web site.
# @status Need to parse command line options with optparse.
#
import ftpdeploy
import sys

objFtpDeploy = ftpdeploy.FtpDeploy()
objFtpDeploy.setFTPlogin('xuser', 'xpass', 'xurl')
objFtpDeploy.setSourceDirectory('/home/raymond/galactic-tools/webdev/deploy/')
objFtpDeploy.setFiles(['file1.txt', 'file2.txt', 'file3.txt'])
objFtpDeploy.setTargetDirectory('/public_html/docs/')
objFtpDeploy.upload()
sys.exit(0)
