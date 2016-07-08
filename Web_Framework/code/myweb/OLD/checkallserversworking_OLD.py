import threading
import os #, os.path
import requests


def f():
    # do something here ...
    try:
        r = requests.get('http://dev.landpotential.org/', timeout=10)
    except requests.exceptions.Timeout:
        commandline = "echo "
        commandline = commandline + '"Automated notification e-mail. Please do not reply. Web Servers are now monitored 24/7"'
        commandline = commandline + " | mail -s "
        commandline = commandline + '"dev.landpotential website is down"'
        commandline = commandline + " essa@nmsu.edu"
        print (commandline)
    
    
    try:
        r = requests.get('http://landpotential.businesscatalyst.com/', timeout=10)
    except requests.exceptions.Timeout:
        commandline = "echo "
        commandline = commandline + '"Automated notification e-mail. Please do not reply. Web Servers are now monitored 24/7"'
        commandline = commandline + " | mail -s "
        commandline = commandline + '"Web businesscatalyst landpotential is down"'
        commandline = commandline + " essa@nmsu.edu"
        print (commandline)

    
    try:
        r = requests.get('http://portallandpotential.businesscatalyst.com/', timeout=10)
    except requests.exceptions.Timeout:
        commandline = "echo "
        commandline = commandline + '"Automated notification e-mail. Please do not reply. Web Servers are now monitored 24/7"'
        commandline = commandline + " | mail -s "
        commandline = commandline + '"Web portal landpotential is down"'
        commandline = commandline + " essa@nmsu.edu"
        print (commandline)


    try:
        r = requests.get('http://testapi.landpotential.org:8080/', timeout=10)
    except requests.exceptions.Timeout:
        commandline = "echo "
        commandline = commandline + '"Automated notification e-mail. Please do not reply. Web Servers are now monitored 24/7"'
        commandline = commandline + " | mail -s "
        commandline = commandline + '"Web testapi is down"'
        commandline = commandline + " essa@nmsu.edu"
        print (commandline)

 
    try:
        r = requests.get('http://portal.landpotential.org/api_explorer', timeout=10)
    except requests.exceptions.Timeout:
        commandline = "echo "
        commandline = commandline + '"Automated notification e-mail. Please do not reply. Servers are now monitored 24/7"'
        commandline = commandline + " | mail -s "
        commandline = commandline + '"Web api_explorer is down"'
        commandline = commandline + " essa@nmsu.edu"
        print (commandline)



    
    os.system(commandline)
    # call f() again in 60 seconds
    threading.Timer(3600, f).start()


if __name__ == '__main__':
    # start calling f now and every 60 sec thereafter
    f()
