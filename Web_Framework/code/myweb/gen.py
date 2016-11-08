import os
from  multiprocessing import Pool
import requests
import datetime
import time

def _inject_settings():
    s = ''
    f = open(os.getcwd() + '/robotframework-scripts/Test_Cases/API/template/Settings.txt', 'r')
    for line in f.readlines():
        s += line
    f.close()
    s += "\n\n"
    return s


def _inject_variables():
    s = ''
    f = open(os.getcwd() + '/robotframework-scripts/Test_Cases/API/template/Variables.txt', 'r')
    for line in f.readlines():
        s += line
    f.close()
    s += "\n\n"
    return s


def _inject_test_cases(file):
    s = "*** Test Cases ***\n"
    f = open(os.getcwd() + '/robotframework-scripts/Test_Cases/API/template/' + file)
    for line in f.readlines():
        words = line.split(",")
        test_case_name = words.pop(0)
        s += test_case_name + "\n"
        s += "\t[Tags]\t" + words.pop(0) + "\n"
        s += "\t${test_case_name}=" + "\tSet Variable\t" + test_case_name + "\n"
        s += "\t${separator}=" + "\tset variable" + "\t;\n"
        s += "\t${line}=" + "\tread a test case from file" + "\t${test_case_name}" + "\t${file}" + "\n"
        s += "\t${query}=" + "\tFetch From Left" + "\t${line}" + "\t${separator}\n"
        s += "\t${status_code}=" + "\tFetch From Right" + "\t${line}" + "\t${separator}\n"
        s += "\t${result}=" + "\tRun a query" + "\t${query}" + "\n"
        s += "\tShould Be Equal As Integers" + "\t${result}" + "\t${status_code}" + "\n\n"
    f.close()
    return s


def _inject_keywords():
    s = "*** Keywords ***\n"
    s += "Run a query\n"
    s += "\t[Arguments]" + "\t${query}" + "\n"
    s += "\t${url}=" + "\tCatenate" + "\tSEPARATOR=" + "\t${host}" + "\tversion=" + "\t${version}" + "\t${query}\n"
    s += "\t${result}=" + "\tinitiate a request" + "\t${url}" + "\n"
    s += "\t[return]" + "\t${result}" + "\n\n"
    s += "Get an ID\n"
    s += "\t[Arguments]" + "\t${query}" + "\n"
    s += "\t${url}=" + "\tCatenate" + "\tSEPARATOR=" + "\t${host}" + "\tversion=" + "\t${version}" + "\t${query}\n"
    s += "\t${ID}=" + "\tSearch for an ID" + "\t${url}\n"
    s += "\tSet Suite Variable" + "\t${ID}\n"
    return s


def _write_to_file(file, s):
    open( os.getcwd() + file, 'w').close()
    f = open(os.getcwd() + file, 'w')
    f.write(s)
    f.close()


def _generate_test_script(scriptfile, testfile):
    s = ''
    s += _inject_settings()
    s += _inject_variables()
    s += _inject_test_cases(testfile)
    s += _inject_keywords()
    _write_to_file("/robotframework-scripts/Test_Cases/API/" + scriptfile, s)


def diff_in_months(d1, d2):
    d1 = datetime.datetime.strptime(d1, "%Y-%m-%d")
    d2 = datetime.datetime.strptime(d2, "%Y-%m-%d")
    return (d2.year - d1.year)*12 + d2.month - d1.month


def def_in_date(beginDate, endDate):
    beginDate =  datetime.datetime.strptime(beginDate, '%Y-%m-%d')
    endDate=  datetime.datetime.strptime(endDate, '%Y-%m-%d')
    delta = endDate -beginDate
    return delta.days + 1

def addmonth(dt0, window):
    dt1 = dt0.split("-")
    y = int(dt1.pop(0))
    m = int(dt1.pop(0))
    d = int(dt1.pop(0))
    m += window
    if (m > 12):
        m = m - 12
        y += 1

    if (len(str(d)) == 1):
        d = "0" + str(d)
    if (len(str(m)) == 1):
        m = "0" + str(m)
    return str(y) + "-" + str(m) + "-" + str(d)


def _fire_a_request(url):
    size_in_byte = 0
    byte_per_sec = 0
    plots = 0
    r = requests.get(url)
    t = time.strptime(str(r.elapsed).split('.')[0], '%H:%M:%S')
    sec = datetime.timedelta(hours=t.tm_hour, minutes=t.tm_min, seconds=t.tm_sec).total_seconds()
    if (sec != 0):
        byte_per_sec = int(float(len(r.content)) / float(sec))
    else:
        byte_per_sec = int(len(r.content))
    size_in_byte = len(r.content)
    plots = r.content.count("recorder_name")
    code = r.status_code
    return "{0},{1},{2},{3},{4},".format(size_in_byte, plots, sec, byte_per_sec, code)

def f(keywords):
    url, reqno, beforeDate, afterDate = keywords.split('|')
    r = open("host", "r")
    result = ''
    for line in r.readlines():
        result += _fire_a_request(url.format(line.replace("\n",''),beforeDate, afterDate))
    r.close()
    result = "{0},{1},{2};".format(reqno, def_in_date(afterDate, beforeDate), result)
    return result.replace(",;", '')


def _performance_measurement(objectType):
    url = []
    afterDate = "2014-09-02"
    beforeDate = "2014-09-02"
    endDate = time.strftime("%Y-%m-%d")  # current date
    window_size_in_months = 2
    end = int(diff_in_months(afterDate, endDate))
    reqno = 0
    for i in range(0, end, window_size_in_months):
        reqno += 1
        if (objectType.lower()=='landinfo'):
            url.append(
                "{0}&action=get&object={6}&type=get_by_beforedate_afterdate&before_date={1}&after_date={2}|{3}|{4}|{5}".format(
                    '{0}', '{1}', '{2}', reqno, beforeDate, afterDate, objectType))
        else:
            url.append(
                "{0}&action=get&object={6}&type=get_by_afterdate_beforedate&after_date={2}&before_date={1}|{3}|{4}|{5}".format(
                    '{0}', '{1}', '{2}', reqno, beforeDate, afterDate, objectType))
        beforeDate = addmonth(beforeDate, window_size_in_months)
    print (time.strftime("%H:%M:%S"))
    pool = Pool(end)
    arr = pool.map(f, url)
    pool.close()
    pool.join()
    print (time.strftime("%H:%M:%S"))
    throughput = ''
    numOfPlot = ''
    sizeInByte = ''
    for i in range(0, len(arr)):
        reqno, days, p_size_in_byte, p_plots, p_sec, p_byte_per_sec, p_code, t_size_in_byte, t_plots, t_sec, \
        t_byte_per_sec, t_code = arr[i].split(",")
        throughput += "[{0}, {1}, {2}]".format(days, p_byte_per_sec, t_byte_per_sec)
        numOfPlot += "[{0}, {1}, {2}]".format(reqno, p_plots, t_plots)
        sizeInByte += "[{0}, {1}, {2}]".format(reqno, p_size_in_byte, t_size_in_byte)

    return "{0};{1};{2}".format(throughput.replace('][', '],['),
            numOfPlot.replace('][', '],['), sizeInByte.replace('][', '],['))


if __name__ == "__main__":
    _generate_test_script("TmpScript.robot", "TmpCases")
    print _performance_measurement("landcover")
    print "=================== end landcover ==============="
    print _performance_measurement("landinfo")

