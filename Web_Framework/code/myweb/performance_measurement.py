# -*- coding: utf-8 -*-

import requests
import time
import random



def randomDate(start, end, format, prop):
   stime = time.mktime(time.strptime(start, format))
   etime = time.mktime(time.strptime(end, format))
   ptime = stime + prop * (etime - stime)
   return time.strftime(format, time.localtime(ptime))


def beforeDateafterDate():
	count = random.randint(1, 5)
	row = count
   	table= [ [ 0 for i in range(2) ] for j in range(row) ]
        tmsg =  "['bit', 'sec'],"
   	while (count > 0):
      		count -= 1
      		afterDate = randomDate("2014-07-01", "2016-12-01", '%Y-%m-%d', random.random())
      		beforeDate  = randomDate("2014-07-01", "2016-12-01", '%Y-%m-%d', random.random())
  		if afterDate > beforeDate:
         		tmp = afterDate
         		afterDate = beforeDate
         		beforeDate = tmp
      		url = "http://api.landpotential.org/query?version=0.1&action=get&object=landinfo&type=get_by_beforedate_afterdate?"
      		tmpurl = url + "before_date=" + beforeDate + "&after_date=" + afterDate
     		START = time.time()
      		r = requests.get(tmpurl)
      		END = time.time()
      		elapased = END - START
      		size = len(r.content)
      		if count > 0 :
                	tmsg = tmsg + (("['%d' ,  %d]," % (size, elapased)))
		else:
			tmsg = tmsg + (("['%d' ,  %d]" % (size, elapased)))
	
	return tmsg
