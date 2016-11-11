def _inject_settings():
    str = ''
    f = open("../template/Settings")
    for line in f.readlines():
        str += line
    f.close()
    str += "\n\n"
    return str


def _inject_variables(self):
    str = ''
    f = open("../template/Variables")
    for line in f.readlines():
        str += line
    f.close()
    str += "\n\n"
    return str


def _inject_test_cases(self, file):
    str = "*** Test Cases ***\n"
    f = open("../template/" + file)
    for line in f.readlines():
        words = line.split(",")
        test_case_name = words.pop(0)
        str += test_case_name + "\n"
        str += "\t[Tags]\t" + words.pop(0) + "\n"
        str += "\t${test_case_name}=" + "\tSet Variable\t" + test_case_name + "\n"
        str += "\t${separator}=" + "\tset variable" + "\t;\n"
        str += "\t${line}=" + "\tread a test case from file" + "\t${test_case_name}" + "\t${file}" + "\n"
        str += "\t${query}=" + "\tFetch From Left" + "\t${line}" + "\t${separator}\n"
        str += "\t${status_code}=" + "\tFetch From Right" + "\t${line}" + "\t${separator}\n"
        str += "\t${result}=" + "\tRun a query" + "\t${query}" + "\n"
        str += "\tShould Be Equal As Integers" + "\t${result}" + "\t${status_code}" + "\n\n"
    f.close()
    return str


def _inject_keywords(self):
    str = "*** Keywords ***\n"
    str += "Run a query\n"
    str += "\t[Arguments]" + "\t${query}" + "\n"
    str += "\t${url}=" + "\tCatenate" + "\tSEPARATOR=" + "\t${host}" + "\tversion=" + "\t${version}" + "\t${query}\n"
    str += "\t${result}=" + "\tinitiate a request" + "\t${url}" + "\n"
    str += "\t[return]" + "\t${result}" + "\n\n"
    str += "Get an ID\n"
    str += "\t[Arguments]" + "\t${query}" + "\n"
    str += "\t${url}=" + "\tCatenate" + "\tSEPARATOR=" + "\t${host}" + "\tversion=" + "\t${version}" + "\t${query}\n"
    str += "\t${ID}=" + "\tSearch for an ID" + "\t${url}\n"
    str += "\tSet Suite Variable" + "\t${ID}\n"
    return str


def _write_to_file(self, file, str):
    f = open(file, "w")
    f.write(str)
    f.close()


def _generate_test_script(self, scriptf, testf):
    str = ''
    str += self._inject_settings()
    str += self._inject_variables()
    str += self._inject_test_cases(testf)
    str += self._inject_keywords()
    f = open("../rfscript/" + scriptf, "w")
    f.write(str)
    f.close()


if __name__ == "__main__":
    _generate_test_script("TestSuites.robot", "TestSuite")

