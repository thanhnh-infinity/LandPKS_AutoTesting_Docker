import os  # , os.path
from cherrypy.lib.static import serve_file
import cherrypy
import sys
from os import walk
import json
import git
import base64
import platform
import gen

SYSTEM = platform.system()


class WebServer(object):
    @cherrypy.expose
    def index(self):
        try:
            hey = GetPath()
            return open(GetPath() + '/index.html')
        except:
            print("Unexpected error:", sys.exc_info()[0])

    def git_clone(self):
        git.Repo.clone_from("https://github.com/LandPotential/LANDPKS_TESTING.git", os.path.dirname(GetPath()))

    def get_files(self):
        f = []

        for (dirpath, dirnames, filenames) in walk(GetPath() + "/robotframework-scripts"):
            for dirname in dirnames:
                for (subpath, subdirpaths, subfiles) in walk(GetPath() + "/robotframework-scripts/" + dirname):
                    for file in subfiles:
                        if (".robot" in file):
                            f.append({"Name": file,
                                      "Path": "{0}\\{1}".format(subpath, file)})
        return json.dumps(f)

    def report_html(self):
        try:
            print GetPath()
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
                # return open(GetPath() + '/utils/RemoteViewer.html')
                string = GetPath() + "/Utils/RemoteRun.jar"
                return serve_file(string, "application/x-download", "attachment")
                # return FileServer().index("Utils\\RemoteRun.jar")
        except:
            print("Unexpected error:", sys.exc_info()[0])

    def chart(self, objecttype):
        try:
            print "gotten into char function"
            result = gen._performance_measurement(objecttype)
            throughput, numOfPlot, sizeInByte = result.split(';')
            return """
                   <!DOCTYPE html>
                   <html lang="en">
                   <head>
                       <meta charset="UTF-8">
                       <title>measuring performance of LandInfo API</title>
                       <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
                       <script type="text/javascript">
                           google.charts.load('current', {packages: ['corechart', 'line']});
                           google.charts.setOnLoadCallback(drawCurveTypes);
                           function drawCurveTypes(){
                               var data = new google.visualization.DataTable();
                               data.addColumn('number', 'X');
                               data.addColumn('number', 'Production_API[http://api.landpotential.org/]');
                               data.addColumn('number', 'Test_API[http://testapi.landpotential.org:8080/]');
                               data.addRows([ """ + throughput + """]);
                               var options = {
                                   title: 'measure of """ + objecttype + """ API performance: get_by_afterdate_beforedate',
                                   legend: { position: 'top' },
                                   hAxis: {
                                       title: 'number of days'
                                   },
                                   vAxis: {
                                       title: 'byte/sec'
                                   },
                                   series: {
                                       1: {curveType: 'function'}
                                   }
                               };

                               var chart = new google.visualization.LineChart(document.getElementById('throughput_div'));
                               chart.draw(data, options);

                               var data1 = new google.visualization.DataTable();
                               data1.addColumn('number', 'X');
                               data1.addColumn('number', 'Production_API: # of plots');
                               data1.addColumn('number', 'Test_API: # of plots');
                               data1.addRows([""" + numOfPlot + """]);

                               var options1 = {
                                   title: 'measure of LandInfo API performance: get_by_afterdate_beforedate',
                                   legend: { position: 'top' },
                                   hAxis: {
                                       title: 'requests by ID'
                                   },
                                   vAxis: {
                                       title: 'number of plots'
                                   },
                                   series: {
                                       1: {curveType: 'function'}
                                   }
                               };

                               var chart1 = new google.visualization.LineChart(document.getElementById('numOfPlot'));
                               chart1.draw(data1, options1);

                               var data2 = new google.visualization.DataTable();
                               data2.addColumn('number', 'X');
                               data2.addColumn('number', 'Production_API: # of Byte');
                               data2.addColumn('number', 'Test_API: # of Byte');
                               data2.addRows([""" + sizeInByte + """]);

                               var options2 = {
                                   title: 'measure of LandInfo API performance: get_by_afterdate_beforedate',
                                   legend: { position: 'top' },
                                   hAxis: {
                                       title: 'requests by ID'
                                   },
                                   vAxis: {
                                       title: 'number of Byte'
                                   },
                                   series: {
                                       1: {curveType: 'function'}
                                   }
                               };

                               var chart2 = new google.visualization.LineChart(document.getElementById('sizeInByte'));
                               chart2.draw(data2, options2);

                           }
                       </script>
                   </head>
                   <body>
                       <tr><div id="throughput_div" style=" min-width: 320px;max-width: 800px;height: 220px;margin: 0 auto;"></div></tr>
                       <tr><div id="numOfPlot" style=" min-width: 320px;max-width: 800px;height: 220px;margin: 0 auto;"></div></tr>
                       <tr><div id="sizeInByte" style=" min-width: 320px;max-width: 800px;height: 220px;margin: 0 auto;"></div></tr>
                   </body>
                   </html>
              """
        except:
            print("Unexpected error:", sys.exc_info()[0])

    # public /log
    log_html.exposed = True
    # Public /report
    report_html.exposed = True
    # Public /chart
    chart.exposed = True
    get_files.exposed = True
    git_clone.exposed = True
    remote_host.exposed = True


class FileServer(object):
    def index(self, fileName):
        string = GetPath() + fileName
        return serve_file(GetPath() + fileName, "application/x-download", "attachment")

    index.exposed = True


class WebService(object):
    exposed = True
    COMMAND = ""
    if (SYSTEM == "Linux"):
        COMMAND = "sudo pybot"
    else:
        COMMAND = "pybot"

    @cherrypy.tools.accept(media='text/plain')
    def POST(self, FileName, TestCase, host, version, ctc):
        try:
            if (FileName == 'Test_Cases/API/TestScript.robot' or FileName == 'Test_Cases/API/TmpScript.robot'):
                path = os.getcwd()
                if (FileName == 'Test_Cases/API/TmpScript.robot'):
                    s = ''
                    for line in ctc.splitlines():
                        s += line + "\n"
                    gen._write_to_file("/robotframework-scripts/Test_Cases/API/template/TmpCases", s)
                    gen._generate_test_script("TmpScript.robot", "TmpCases")
                    url = "pybot --variable host:{0} --variable version:{1} --outputdir {2}/output {2}/robotframework-scripts/{3}".format(
                        host, version, path, FileName)
                else:
                    url = "pybot --include {0} --variable host:{1} --variable version:{2} --outputdir {3}/output {3}/robotframework-scripts/{4}".format(
                        TestCase, host, version, path, FileName)
            else:
                url = "{3} --include {0} --outputdir {2}/output {2}/robotframework-scripts/{1}".format(TestCase,
                                                                                                       FileName,
                                                                                                       GetPath(),
                                                                                                       self.COMMAND)
            if (SYSTEM == "Windows"):
                url = url.replace("/", "\\")
            print url
            os.system(url)
            return "DONE!"

        except:
            print("Unexpected error:", sys.exc_info()[0])


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
            'response.timeout': 60000
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
    cherrypy.config.update({'server.socket_host': '127.0.0.1',  # '128.123.177.106',
                            'server.socket_port': 7072
                            })
    cherrypy.quickstart(webapp, '/', conf)
