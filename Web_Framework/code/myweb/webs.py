import os #, os.path
import random
import string

from subprocess import call
import cherrypy
import shutil
import sys
import performance_measurement
import threading
from os import walk
import json
import git

class WebServer(object):
    @cherrypy.expose
    def index(self):
	try:
		return open('/home/essa/workspace/code/myweb/index.html')
	except:
		print("Unexpected error:", sys.exc_info()[0])


    def readfile(self):
	 return performance_measurement.beforeDateafterDate()
    def git_clone(self):
        git.Repo.clone_from("https://github.com/LandPotential/LANDPKS_TESTING.git",os.path.dirname(os.path.abspath(os.getcwd())))
    def get_files(self):
        f = []
        
        for (dirpath,dirnames,filenames) in walk(os.path.abspath(os.getcwd())+"/robotframework-scripts"):
            for dirname in dirnames:
                for (subpath,subdirpaths,subfiles) in walk(os.path.abspath(os.getcwd())+"/robotframework-scripts/"+dirname):
                    for file in subfiles:
                        if(".robot" in file):
                            f.append({"Name" : file,
                                      "Path":"{0}\\{1}".format(subpath,file)})
        return json.dumps(f)
    def report_html(self):
	try:
        	return open('/home/essa/workspace/code/myweb/output/report.html')
	except:
                print("Unexpected error:", sys.exc_info()[0])


    
    def log_html(self):
	try:
        	return open('/home/essa/workspace/code/myweb/output/log.html')
	except:
                print("Unexpected error:", sys.exc_info()[0])



    def chart(self):
	try:
		msgme = performance_measurement.beforeDateafterDate()
        	htmlpage = """<html>
  			<head>
    				<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
   				<script type="text/javascript">
      				google.charts.load('current', {'packages':['corechart']});
      				google.charts.setOnLoadCallback(drawChart);
      				function drawChart() {
        				var data = google.visualization.arrayToDataTable([""" + msgme + """]);
        				var options = {
          					title: 'API Performance',
          					curveType: 'function',
          					legend: { position: 'bottom' }
        				};
        				var chart = new google.visualization.LineChart(document.getElementById('curve_chart'));
        				chart.draw(data, options);
      				}
    				</script>
 			 </head>
  			<body>
    				<div id="curve_chart" style="width: 900px; height: 500px"></div>
 			 </body>
		</html>"""
	        return htmlpage
	except:
                print("Unexpected error:", sys.exc_info()[0])

    #public /log
    log_html.exposed = True
    #Public /report
    report_html.exposed = True
    #Public /chart
    chart.exposed = True
    #Public /readfile
    readfile.exposed = True
    get_files.exposed=True
    git_clone.exposed=True

class WebService(object):
     exposed = True

     @cherrypy.tools.accept(media='text/plain')
     def GET(self):
         return cherrypy.session['mystring']


     def POST(self, FileName, TestCase):
         url = "sudo pybot --include {0} --outputdir /home/essa/workspace/code/myweb/output /home/essa/workspace/code/myweb/robotframework-scripts/{1}".format(TestCase,FileName)
        # call(["pybot --outputdir output1 ", url])
         os.system( url)
         #shutil.copy2('/report.html', '/root/workspace/code/myweb/report.html')
         #shutil.copy2('/log.html', '/root/workspace/code/myweb/log.html')
         return "DONE!"

     def PUT(self, another_string):
         cherrypy.session['mystring'] = another_string


     def DELETE(self):
         cherrypy.session.pop('mystring', None)



if __name__ == '__main__':
     conf = {
         '/': {
             'tools.sessions.on': True,
         },
         '/luncher': {
             'request.dispatch': cherrypy.dispatch.MethodDispatcher(),
             'tools.response_headers.on': True,
             'tools.response_headers.headers': [('Content-Type', 'text/plain')],
         }
     }
     webapp = WebServer()
     webapp.luncher = WebService()
     cherrypy.config.update({'server.socket_host': 'essa.landpotential.org',
                            'server.socket_port': 7070
                          })
     cherrypy.quickstart(webapp, '/', conf)
