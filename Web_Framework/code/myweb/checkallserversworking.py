import threading
import os #, os.path
import requests
from socket import gethostbyname 
import smtplib
import json
import sys
from time import sleep
DEV_SERVER = 'dev.landpotential.org'
BUSINESS_CATALYST = 'landpotential.businesscatalyst.com'
PORTAL_HOST = 'portallandpotential.businesscatalyst.com'
TEST_API = 'testapi.landpotential.org'
API_EXPLORER = 'portal.landpotential.org'
SERVER_STAT_IDX = 'Status'
SERVER_NAME_IDX = 'Server'
MAIL_SENT_IDX = 'MailSent'
JSON_SERVER_NAME_IDX = 'ServerName'
JSON_SERVER_IP_IDX = 'IPAddr'
SERVER_STAT_FILENAME = 'ServerStatus.sts'
REQUEST_STRING = 'StringForRequest'
def PutStatus(Server, Status, ServerStatus):
    #Unused this is for later
    for i in range(0,len(ServerStatus)):
        if ServerStatus[i][SERVER_NAME_IDX] == Server:
            ServerStatus[i][SERVER_STAT_IDX] = Status
            break
def GetStatusByServerName(ServerName, ServerStatuses):
    #Unused this is for later
    for i in range(0,len(ServerStatuses)):
        if ServerStatuses[i][SERVER_NAME_IDX] == ServerName:
            return i
def InstanciateServerStatus():
    #If no file was located this function creates the struct and file
    ServerStatus = {
                DEV_SERVER : {
                              SERVER_STAT_IDX : '',
                              MAIL_SENT_IDX : False,
                              REQUEST_STRING: 'http://{0}'
                              },
                BUSINESS_CATALYST : {
                                     SERVER_STAT_IDX : '',
                                     MAIL_SENT_IDX : False,
                                     REQUEST_STRING: 'http://{0}'
                                    },
                PORTAL_HOST : {
                               SERVER_STAT_IDX : '',
                               MAIL_SENT_IDX : False,
                               REQUEST_STRING: 'http://{0}'
                               },
                TEST_API : {
                            SERVER_STAT_IDX : '',
                            MAIL_SENT_IDX : False,
                            REQUEST_STRING: 'http://{0}:8080'
                            },
                API_EXPLORER : {SERVER_STAT_IDX : '',
                                MAIL_SENT_IDX : False,
                                REQUEST_STRING: 'http://{0}/api_explorer'
                                }
                }
    OutputServerStatus(ServerStatus)
    return ServerStatus
def OLDMETHOD(ServerStats,JsonData):
    try:
        requests.get('http://{0}'.format(DEV_SERVER), timeout=10)
        #server is found and sets the struct as such
        ServerStats[DEV_SERVER][SERVER_STAT_IDX] = True
    except requests.exceptions.Timeout:
        ip = gethostbyname(DEV_SERVER)
        #Server was not found, sets the struct as such and loads info into a json struct to send to gmail smtp
        JsonData.append({
                         JSON_SERVER_NAME_IDX : DEV_SERVER,
                         JSON_SERVER_IP_IDX : ip
                         })
        ServerStats[DEV_SERVER][SERVER_STAT_IDX] = False
    try:
        requests.get('http://{0}'.format(BUSINESS_CATALYST), timeout=10)
        ServerStats[BUSINESS_CATALYST][SERVER_STAT_IDX] = True
    except requests.exceptions.Timeout:
        ip = gethostbyname(BUSINESS_CATALYST) 
        JsonData.append({
                         JSON_SERVER_NAME_IDX : BUSINESS_CATALYST,
                         JSON_SERVER_IP_IDX : ip
                         })
        ServerStats[BUSINESS_CATALYST][SERVER_STAT_IDX] = False
    try:
        requests.get('http://{0}'.format(PORTAL_HOST), timeout=10)
        ServerStats[PORTAL_HOST][SERVER_STAT_IDX] = True
    except requests.exceptions.Timeout:
        ip = gethostbyname(PORTAL_HOST)
        JsonData.append({
                         JSON_SERVER_NAME_IDX : PORTAL_HOST,
                         JSON_SERVER_IP_IDX : ip
                         })
        ServerStats[PORTAL_HOST][SERVER_STAT_IDX] = False
    try:
        requests.get('http://{0}:8080'.format(TEST_API), timeout=10)
        ServerStats[TEST_API][SERVER_STAT_IDX] = True
    except requests.exceptions.Timeout:
        ip = gethostbyname(TEST_API)
        JsonData.append({
                         JSON_SERVER_NAME_IDX : TEST_API,
                         JSON_SERVER_IP_IDX : ip
                         })
        ServerStats[TEST_API][SERVER_STAT_IDX] = False
    try:
        requests.get('http://{0}/api_explorer'.format(API_EXPLORER), timeout=10)
        ServerStats[API_EXPLORER][SERVER_STAT_IDX] = True
    except requests.exceptions.Timeout:
        ip = gethostbyname(API_EXPLORER)
        JsonData.append({
                         JSON_SERVER_NAME_IDX : API_EXPLORER,
                         JSON_SERVER_IP_IDX : ip
                         })
        ServerStats[API_EXPLORER][SERVER_STAT_IDX] = False
def LoadServerStatus():
    #loads the file from system and fills the struct containing server statuses
    FileServerStatus = open(SERVER_STAT_FILENAME , 'r+')
    ret = json.loads(FileServerStatus.read())
    FileServerStatus.close()
    return ret
def f():
    ServerStats = []
    try:
        ServerStats = LoadServerStatus()
    except Exception:
        ServerStats = InstanciateServerStatus()
    JsonData=[];
    #For loop does old method but less management, Dynamic
    for Server in ServerStats :
        try:
            requests.get((ServerStats[Server][REQUEST_STRING]).format(Server))
            #server is found and sets the struct as such
            ServerStats[Server][SERVER_STAT_IDX] = True
        except requests.exceptions.Timeout :
            ip = gethostbyname(ServerStats[Server])
            #Server was not found, sets the struct as such and loads info into a json struct to send to gmail smtp
            JsonData.append({
                             JSON_SERVER_NAME_IDX : ServerStats[Server],
                             JSON_SERVER_IP_IDX : ip
                             })
            ServerStats[Server][SERVER_STAT_IDX] = False
    #OldMethod went here just in case
    
    #sendMain(JsonData)
    
    #Removes the servers that have already been mailed from the json struct
    RemoveMailed(JsonData,ServerStats)
    #Processes both servers that went down and servers that came back up and mails accordingly
    ProcMails(JsonData,ServerStats)
    #Writes server status to file
    OutputServerStatus(ServerStats)
def ProcMails(JsonData,ServerStats):
    Remails = GetRemails(ServerStats)
    if(len(Remails) > 0 ):
        sendMain(Remails,ServerStats,False)
    if(len(JsonData) > 0 ):
        sendMain(JsonData,ServerStats)
def OutputServerStatus(ServerStats):
    FileServerStatus = open(SERVER_STAT_FILENAME , 'w+')
    FileServerStatus.write(json.dumps(ServerStats))
    FileServerStatus.close()
def GetRemails(ServerStats):
    Remails=[]
    for Server in ServerStats:
        if ServerStats[Server][MAIL_SENT_IDX] and ServerStats[Server][SERVER_STAT_IDX]:
            ip = gethostbyname(Server)
            Remails.append({
                         JSON_SERVER_NAME_IDX : Server,
                         JSON_SERVER_IP_IDX : ip
                         })
    return Remails
            
def RemoveMailed(JData, ServerStatuses):
    #Removes server from json if it has already been mailed
    RetData = []
    Start = len(JData) - 1
    while Start >=0:
        if(ServerStatuses[JData[Start][JSON_SERVER_NAME_IDX]][MAIL_SENT_IDX] == True):
            RetData.append(JData[Start])
            del JData[Start]
        Start -= 1
    return RetData
def buildMessage(JData, ServerStats, bDown=True):
    #bDown sets whether to send message that server has come back up or that it went down
    if (bDown):
        Message ='From: Server status \nSubject: Server Down\n\n'
        for Data in JData:
            Message += 'Server {0} located at {1} is currently down'.format(Data[JSON_SERVER_NAME_IDX], Data[JSON_SERVER_IP_IDX])
            ServerStats[Data[JSON_SERVER_NAME_IDX]][MAIL_SENT_IDX] = True
    else:
        Message ='From: Server status c \nSubject: Server Came Back Up\n\n'
        for Data in JData:
            Message += 'Server {0} located at {1} came back up after being down\n'.format(Data[JSON_SERVER_NAME_IDX], Data[JSON_SERVER_IP_IDX])
            ServerStats[Data[JSON_SERVER_NAME_IDX]][MAIL_SENT_IDX] = False
    return Message
def sendMain(JData,ServerStats, bDown=True):
    addrFrom = 'lpks.test@gmail.com'
    addrTo = ['barnebre@gmail.com','essa@nmsu.edu']
    Message = buildMessage(JData,ServerStats, bDown)
    addrFrom = 'lpks.test@gmail.com'
    password = 'landpotentialtest'
    server = smtplib.SMTP('smtp.gmail.com:587')
    server.starttls()
    server.login(addrFrom,password)
    server.sendmail(addrFrom, addrTo, Message)
    server.quit()
if __name__ == '__main__':
    #essa this had to be changed... it only fired once. Timer kills thread after executing. Now it runs until stopped. The timer would just launch it once after x time
    #The while loop will now relaunch
    # start calling f now and every 60 sec thereafter
    timer = 1800
    if(len(sys.argv)>=2):
        try:
            timer = int(float(sys.argv[1]))
        except ValueError:
            timer = 1800
    Threader = threading.Timer(timer, f)
    while(True):
        if(not Threader.isAlive()):
            Threader = threading.Timer(timer, f)
            Threader.start()
        sleep(timer+5)
    inpt = ''
    
        
