import base64
import json
import os #, os.path
import platform
import sys
from os import walk

import cherrypy
import git
from cherrypy.lib.static import serve_file

import performance_measurement

SYSTEM = platform.system()
class WebServer(object):

    @cherrypy.expose
    def index(self):
        try:
            hey = GetPath()
            return open(GetPath() + '/index.html')
        except:
            print("Unexpected error:", sys.exc_info()[0])

    def readfile(self):
        return performance_measurement.beforeDateafterDate()
    def git_clone(self):
        git.Repo.clone_from("https://github.com/LandPotential/LANDPKS_TESTING.git",os.path.dirname(GetPath()))
    def get_files(self):
        f = []
        
        for (dirpath,dirnames,filenames) in walk(GetPath()+"/robotframework-scripts"):
            for dirname in dirnames:
                for (subpath,subdirpaths,subfiles) in walk(GetPath()+"/robotframework-scripts/"+dirname):
                    for file in subfiles:
                        if(".robot" in file):
                            f.append({"Name" : file,
                                      "Path":"{0}\\{1}".format(subpath,file)})
        return json.dumps(f)
    def report_html(self):
        try:
            return open(GetPath() + '/output/report.html')
        except:
            print("Unexpected error:", sys.exc_info()[0])
        

    
    def log_html(self):
        try:
            return open(GetPath() + '/output/log.html')
        except:
            print("Unexpected error:", sys.exc_info()[0])
    def remote_host(self, key):
        try:
            if (key == base64.b64decode(open(GetPath() + "/Utils/key.hexo").read())):
                #return open(GetPath() + '/utils/RemoteViewer.html')
                string = GetPath() + "/Utils/RemoteRun.jar"
                return serve_file(string,  "application/x-download", "attachment")
            #return FileServer().index("Utils\\RemoteRun.jar")
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
    remote_host.exposed=True
class FileServer(object):
    def index(self, fileName):
        string = GetPath() + fileName
        return serve_file(GetPath() + fileName,  "application/x-download", "attachment")
    index.exposed = True
class WebService(object):
    exposed = True
    COMMAND = ""
    if (SYSTEM == "Linux"):
        COMMAND = "sudo pybot"
    else:
        COMMAND= "pybot"
    @cherrypy.tools.accept(media='text/plain')
    def GET(self):
        return cherrypy.session['mystring']
    def POST(self, FileName, TestCase, host, version):
        if (FileName == 'Test_Cases/API/TestScript.robot'):
            url = "sudo pybot --include {0} --variable host:{2} --variable version:{3} --outputdir /home/essa/workspace/code/myweb/output /home/essa/workspace/code/myweb/robotframework-scripts/{1}".format(TestCase,FileName,host,version)
        else:
            url = "{3} --include {0} --outputdir {2}/output {2}/robotframework-scripts/{1}".format(TestCase,FileName,GetPath(),self.COMMAND)
        if(SYSTEM == "Windows"):
            url = url.replace("/", "\\")
        os.system( url)
        #shutil.copy2('/report.html', '/root/workspace/code/myweb/report.html')
        #shutil.copy2('/log.html', '/root/workspace/code/myweb/log.html')
        return "DONE!"
    def PUT(self, another_string):
        cherrypy.session['mystring'] = another_string
    def DELETE(self):
        cherrypy.session.pop('mystring', None)


def GetPath():
    try:
        modpath = __file__
    except AttributeError:
        sys.exit('Module does not have __file__ defined.')
    # It's a script for me, you probably won't want to wrap it in try..except

    # Turn pyc files into py files if we can
    if modpath.endswith('.pyc') and os.path.exists(modpath[:-1]):
        modpath = modpath[:-1]

# Sort out symlinks
    modpath = os.path.dirname(os.path.realpath(modpath))
    return modpath
print GetPath()
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
    webapp.download = FileServer()
    cherrypy.config.update({'server.socket_host': 'essa.landpotential.org', #'128.123.177.106',
                            'server.socket_port': 7070
                          })
    cherrypy.quickstart(webapp, '/', conf)
