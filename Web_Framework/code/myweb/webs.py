import os  # , os.path
import requests
from cherrypy.lib.static import serve_file
import cherrypy
import sys
from os import walk
import json
import git
import base64
import platform
import gen
import jenkinsapi
import datetime
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
    def Archive_Table(self,JenkinsURL,jobName = 'all'):
        Jenkins =jenkinsapi.jenkins.Jenkins(JenkinsURL)
        return buildTable(Jenkins,jobName)
    def Get_Last_Build(self,JenkinsURL,jobName):
        Jenkins =jenkinsapi.jenkins.Jenkins(JenkinsURL)
        return getLastBuild(Jenkins,jobName)
        #jenkinsapi.job.Job.get_build_metadata(self, buildnumber)(self)
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
    Archive_Table.exposed=True
    Get_Last_Build.exposed=True

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
    def GET(self):
        return cherrypy.session['mystring']

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

def GetBuildInfo(RequestString):
    response = requests.put(RequestString)
    ResponseText = response.text
    response.close()
    return ResponseText
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
def BuildRowForJenksTable(JobBuildNumber,urlToJob,JobMetaData):
    RetString = '{0}{1}{2}{3}</tr>'
    BuildNumber = '</tr><tr><th scope="row">{0}</th>\n'.format(JobBuildNumber)
    UrlLine = '<td>{0}{1}</a></td>\n'.format(urlToJob,'Url to Results')
    ReadableDate = datetime.datetime.fromtimestamp(
        int(JobMetaData['timestamp']/1000)
        ).strftime('%Y-%m-%d %H:%M:%S')
    TimeField = '<td>{0}</td>\n'.format(ReadableDate)
    Status = '<td>{0}</td>\n'.format(JobMetaData['result'])
    return RetString.format(BuildNumber, Status, TimeField, UrlLine)
def buildTable(Jenkins,jobName):
    HtmlString = '''<html><body><div class="content">
    <table align="left" border="1" cellpadding="1" cellspacing="1"><thead><tr><th scope="row">Build Number</th>
    <th scope="col">Status</th>
    <th scope="col">Built On</th>
    <th scope="col">URL</th>
    </thead><tbody>'''
    if(jobName.lower() == 'all'):
        JenkinsJob = Jenkins.get_jobs()
    else:
        JenkinsJob = Jenkins.get_job(jobName)
    Builds = JenkinsJob.get_build_dict()
    TableTemp = ""
    for BuildNumber in Builds:
        
        urlToJob = '<a href="{0}/robot">'.format(Builds[BuildNumber])
        meta = JenkinsJob.get_build_metadata(BuildNumber)
        TableHtml = BuildRowForJenksTable(BuildNumber, urlToJob, meta._data)
        TableHtml += TableTemp
        TableTemp = TableHtml
        #HtmlString += BuildRowForJenksTable(BuildNumber, urlToJob, meta._data)
    HtmlString += TableTemp
    HtmlString += "</tbody></table></body></html>"
    return HtmlString
def getLastBuild(Jenkins,jobName):
    ReadableDate = """
    <script type="text/javascript">
    setTimeout(function(){
    window.location.reload(1);
    }, 20000);
    </script>
    """
    if "LandPKS_Web_App_Testing" in jobName and not "Production" in jobName:
        StringBuild = GetBuildInfo("http://128.123.177.36:8080/job/LandCover_Mobile_Andoird_App/ws/www/js/configuration.js")
        StartInt = StringBuild.find("var LANDPKS_MOBILE_APP_VERSION = '") + len("var LANDPKS_MOBILE_APP_VERSION = '")
        EndInt = StringBuild.find("'",StartInt)
        BuildInfo = StringBuild[StartInt : EndInt]
    elif "LandPKS_Web_App_Testing" in jobName and "Production" in jobName:
        BuildInfo = "2.0.10"
    elif "LandPKS_Android_Mobile_Testing" in jobName and not "Production" in jobName :
        #StringBuild = GetBuildInfo("http://128.123.177.36:8080/job/LandCover_Mobile_Andoird_App/ws/platforms/android/AndroidManifest.xml")
        #StartInt = StringBuild.find('android:versionName="') + len('android:versionName="')
        #EndInt = StringBuild.find('"',StartInt)
        #BuildInfo = StringBuild[StartInt : EndInt]
        StringBuild = GetBuildInfo("http://128.123.177.36:8080/job/LandCover_Mobile_Andoird_App/ws/www/js/configuration.js")
        StartInt = StringBuild.find("var LANDPKS_MOBILE_APP_VERSION = '") + len("var LANDPKS_MOBILE_APP_VERSION = '")
        EndInt = StringBuild.find("'",StartInt)
        BuildInfo = StringBuild[StartInt : EndInt]
    elif "LandPKS_Android_Mobile_Testing" in jobName and "Production" in jobName :
        BuildInfo = "2.0.10"
    JenkinsJob = Jenkins.get_job(jobName)
    
    #jenkinsapi.job.Job.get_last_buildnumber(self)
    Builds = JenkinsJob.get_build_dict()
    lastbuild = JenkinsJob.get_last_buildnumber()
    meta = JenkinsJob.get_build_metadata(JenkinsJob.get_last_buildnumber())
    #ReadableDate = datetime.datetime.fromtimestamp(
    #    int(meta._data['timestamp']/1000)
    #    ).strftime('%Y-%m-%d %H:%M:%S')
    if meta._data['result'] == "FAILURE":
        ReadableDate += '<font size="3" color="red">{0}</font>'.format(datetime.datetime.fromtimestamp(
                                                                                                      int(meta._data['timestamp']/1000)
                                                                                                      ).strftime('%Y-%m-%d %H:%M:%S')
                                                                      )
        if "LandPKS_Web_App_Testing" in jobName and not "Production" in jobName:
            ReadableDate += ' - Build {0}'.format(BuildInfo)
        elif "LandPKS_Android_Mobile_Testing" in jobName and not "Production" in jobName :
            ReadableDate += ' - Build {0}'.format(BuildInfo)
    elif meta._data['result'] == "ABORTED":
        ReadableDate += '<font size="3" color="gray">{0}</font>'.format(datetime.datetime.fromtimestamp(
                                                                                                      int(meta._data['timestamp']/1000)
                                                                                                      ).strftime('%Y-%m-%d %H:%M:%S')
                                                                      )
        if "LandPKS_Web_App_Testing" in jobName and not "Production" in jobName:
            ReadableDate += ' - Build {0}'.format(BuildInfo)
        elif "LandPKS_Android_Mobile_Testing" in jobName and not "Production" in jobName :
            ReadableDate += ' - Build {0}'.format(BuildInfo)
    elif meta._data['building']:
        ReadableDate += """
<script type="text/javascript">
  function blink() {
    var blinks = document.getElementsByTagName('blink');
    for (var i = blinks.length - 1; i >= 0; i--) {
      var s = blinks[i];
      s.style.visibility = (s.style.visibility === 'visible') ? 'hidden' : 'visible';
    }
    window.setTimeout(blink, 1000);
  }
  if (document.addEventListener) document.addEventListener("DOMContentLoaded", blink, false);
  else if (window.addEventListener) window.addEventListener("load", blink, false);
  else if (window.attachEvent) window.attachEvent("onload", blink);
  else window.onload = blink;
</script>
<blink><font size="3" color="blue">%s</font></blink>"""% datetime.datetime.fromtimestamp(
                                                                                                      int(meta._data['timestamp']/1000)
                                                                                                      ).strftime('%Y-%m-%d %H:%M:%S')
                                    #                                  )
        if "LandPKS_Web_App_Testing" in jobName :
            ReadableDate += ' - Build {0}'.format(BuildInfo)
        elif "LandPKS_Android_Mobile_Testing" in jobName :
            ReadableDate += ' - Build {0}'.format(BuildInfo)
    else:
        ReadableDate += '<font face="verdana" color="green">{0}</font>'.format(datetime.datetime.fromtimestamp(
                                                                                                      int(meta._data['timestamp']/1000)
                                                                                                      ).strftime('%Y-%m-%d %H:%M:%S')
                                                                      )
        if "LandPKS_Web_App_Testing" in jobName :
            ReadableDate += ' - Build {0}'.format(BuildInfo)
        elif "LandPKS_Android_Mobile_Testing" in jobName :
            ReadableDate += ' - Build {0}'.format(BuildInfo)
    return ReadableDate
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
    cherrypy.config.update({'server.socket_host': 'lpkstesttools.landpotential.org',#'127.0.0.1',#'lpkstesttools.landpotential.org',# '127.0.0.1', # '128.123.177.106',
                            'server.socket_port': 7070
                            })
    cherrypy.quickstart(webapp, '/', conf)
