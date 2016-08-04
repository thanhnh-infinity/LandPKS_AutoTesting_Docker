import os


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


if __name__ == "__main__":
    _generate_test_script("TmpScript.robot", "TmpCases")

