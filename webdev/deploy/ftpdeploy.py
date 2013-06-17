#!/usr/bin/python3.2
from ftplib import FTP
import os
import sys

class FtpDeploy:
	'FtpDeploy: a class that helps deploy code onto a web server'
	def __init__(self):
		print('FtpDeploy::__init__')
		self.sourceDirectory = '' # sourceDirectory: where code
					  # is retrieved.  All files in
					  # self.files are relative to
				 	  # sourceDirectory.
		self.targetDirectory = '' # targetDirectory: where the code
					  # will be placed upon upload.
		self.files = []	 	  # An empty list
		self.user = ''
		self.password = ''
		self.url = ''
	
	def setFiles(self, files):
		print('FtpDeploy::setFiles')
		for element in files:
			self.files.append(element)

	def setSourceDirectory(self, sourceDirectory):
		self.sourceDirectory = sourceDirectory

	def setTargetDirectory(self, targetDirectory):
		self.targetDirectory = targetDirectory

	def setFTPlogin(self, user, password, url):
		self.user = user
		self.password = password
		self.url = url

	def upload(self):
		print('FtpDeploy::upload')
		ftp = FTP(self.url)
		ftp.login(self.user, self.password)
		for element in self.files:
			srcFilePath = self.sourceDirectory + element
			tgtFilePath = self.targetDirectory + element
			print('srcFilePath=', srcFilePath)
			print('tgtFilePath=', tgtFilePath)
			# continue
			fhndl = open(srcFilePath, 'rb')
			ftp.storbinary('STOR ' + tgtFilePath, fhndl)
			fhndl.close()	
		ftp.quit()

	def download():
		print('FtpDeploy::download')

ftpObj = FtpDeploy()
ftpObj.setFTPlogin('xuser', 'xpass' 'xurl')
ftpObj.setSourceDirectory('/home/raymond/galactic-tools/webdev/deploy/')
ftpObj.setFiles(['file1.txt', 'file2.txt', 'file3.txt'])
ftpObj.setTargetDirectory('/public_html/docs/')
ftpObj.upload()
sys.exit(0)

ftp = FTP('xurl')
ftp.login('xuser', 'xpass')
ftp.retrlines('LIST')
foohndl = open('foo.txt', 'rb') 
ftp.storbinary('STOR /public_html/docs/foo.txt', foohndl)
# ftp.storbinary('STOR /public_html/docs/foo.txt', 'foo.txt')
ftp.quit()
close(foohndl)
